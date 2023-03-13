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
                context.read<FileBloc>().add(FileEventToggleSelected(key));
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
    return Row(
      children: [
        const Text('图片资源'),
        const Spacer(),
        IconButton(
          icon: Icon(editable ? Icons.lock : Icons.lock_open),
          onPressed: () {
            onEditableChanged(!editable);
          },
        ),
        if (editable)
          IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: onUpload,
          ),
        if (editable && selectedKeys.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
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
          ),
      ],
    );
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
    return SizedBox(
      height: 400,
      width: 600,
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: images.length,
        itemBuilder: (context, index) {
          final image = images[index];
          if (editable) {
            return Stack(
              children: [
                Image.network(image.url),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon: Icon(selectedKeys.contains(image.key)
                        ? Icons.check_box
                        : Icons.check_box_outline_blank),
                    onPressed: () {
                      onSelected(image.key);
                    },
                  ),
                ),
              ],
            );
          } else {
            return InkWell(
              onTap: () {
                Navigator.of(context).pop(image);
              },
              child: Image.network(image.url),
            );
          }
        },
      ),
    );
  }
}
