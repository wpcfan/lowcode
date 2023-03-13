import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_repository/page_repository.dart';
import 'package:provider/provider.dart';

import '../../blocs/file_bloc.dart';
import '../../blocs/file_state.dart';
import '../../blocs/flie_event.dart';

class ImageExplorer extends StatelessWidget {
  const ImageExplorer({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<FileUploadRepository>(
          create: (context) => FileUploadRepository(),
        ),
        RepositoryProvider<FileAdminRepository>(
          create: (context) => FileAdminRepository(),
        ),
      ],
      child: MultiProvider(
        providers: [
          BlocProvider<FileBloc>(
            create: (context) => FileBloc(
              fileRepo: context.read<FileUploadRepository>(),
              fileAdminRepo: context.read<FileAdminRepository>(),
            )..add(FileEventLoad()),
          ),
        ],
        child: BlocBuilder<FileBloc, FileState>(
          builder: (context, state) {
            if (state.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state.error.isNotEmpty) {
              return Center(
                child: Text(state.error),
              );
            }

            if (state.files.isEmpty) {
              return const Center(
                child: Text('没有图片资源'),
              );
            }

            /// 由于在异步操作中，往往上下文会发生变化，所以需要在这里先把 bloc 拿出来
            /// 在下面的回调中使用，这样就不用关心上下文是否发生变化，如果每次都使用 context.read<FileBloc>()
            /// 那么在异步操作中，就会报错
            final bloc = context.read<FileBloc>();
            final images = state.files;
            final title = FileDialogTitle(
              editable: state.editable,
              selectedKeys: state.selectedKeys,
              onEditableChanged: (value) {
                bloc.add(FileEventToggleEditable());
              },
              onDelete: () {
                bloc.add(FileEventDelete());
              },
              onUpload: () async {
                final picker = ImagePicker();
                final pickedImages = await picker.pickMultiImage();

                final List<UploadFile> images = [];
                for (var image in pickedImages) {
                  final bytes = await image.readAsBytes();
                  images.add(UploadFile(
                    name: image.name,
                    file: bytes,
                  ));
                }

                if (images.isNotEmpty) {
                  bloc.add(FileEventUploadMultiple(images));
                }
              },
            );
            final content = FileDialogContent(
              images: images,
              editable: state.editable,
              selectedKeys: state.selectedKeys,
              onSelected: (key) {
                bloc.add(FileEventToggleSelected(key));
              },
            );
            final actions = [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('取消'),
              ),
            ];
            return AlertDialog(
              title: title,
              content: content,
              actions: actions,
            );
          },
        ),
      ),
    );
  }
}

class FileDialogTitle extends StatelessWidget {
  const FileDialogTitle({
    super.key,
    required this.editable,
    required this.selectedKeys,
    required this.onEditableChanged,
    required this.onUpload,
    required this.onDelete,
  });
  final bool editable;
  final List<String> selectedKeys;
  final void Function(bool) onEditableChanged;
  final void Function() onUpload;
  final void Function() onDelete;

  @override
  Widget build(BuildContext context) {
    /// 编辑按钮
    final editableIcon = Icon(editable ? Icons.lock : Icons.lock_open).inkWell(
      onTap: () => onEditableChanged(!editable),
    );

    /// 上传按钮
    final uploadIcon = const Icon(Icons.upload_file).inkWell(
      onTap: onUpload,
    );

    /// 删除按钮
    final deleteIcon = const Icon(Icons.delete).inkWell(
      onTap: () async {
        if (selectedKeys.isEmpty) {
          return;
        }
        final result = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('删除图片'),
            content: const Text('确定要删除这些图片吗？'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('取消'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('确定'),
              ),
            ],
          ),
        );
        if (result == true) {
          onDelete();
        }
      },
    );
    return [
      const Text('图片资源'),
      const Spacer(),
      editableIcon,
      if (editable) uploadIcon,
      if (editable && selectedKeys.isNotEmpty) deleteIcon,
    ].toRow();
  }
}

class FileDialogContent extends StatelessWidget {
  const FileDialogContent({
    super.key,
    required this.images,
    required this.editable,
    required this.selectedKeys,
    required this.onSelected,
  });
  final List<FileDto> images;
  final bool editable;
  final List<String> selectedKeys;
  final void Function(String) onSelected;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        final image = images[index];

        /// 非编辑模式下的图片
        final selectableItem = Image.network(image.url).inkWell(
          onTap: () => Navigator.of(context).pop(image),
        );

        /// 编辑模式下的图片
        final editableItem = [
          Image.network(image.url),
          Icon(selectedKeys.contains(image.key)
                  ? Icons.check_box
                  : Icons.check_box_outline_blank)
              .inkWell(
                onTap: () => onSelected(image.key),
              )
              .positioned(
                top: 0,
                right: 0,
              ),
        ].toStack();
        return editable ? editableItem : selectableItem;
      },
    ).constrained(
      width: 400,
      height: 600,
    );
  }
}
