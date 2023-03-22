import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nested/nested.dart';
import 'package:repositories/repositories.dart';

import 'blocs/blocs.dart';
import 'widgets/widgets.dart';

class ImageExplorer extends StatelessWidget {
  const ImageExplorer({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: _buildRepositoryProviders,
      child: MultiBlocProvider(
        providers: _buildBlocProviders,
        child: BlocBuilder<FileBloc, FileState>(
          builder: (context, state) {
            if (state.loading) {
              return const CircularProgressIndicator().center();
            }

            if (state.error.isNotEmpty) {
              return Text(state.error).center();
            }

            if (state.files.isEmpty) {
              return const Text('没有图片资源').center();
            }

            /// 由于在异步操作中，往往上下文会发生变化，所以需要在这里先把 bloc 拿出来
            /// 在下面的回调中使用，这样就不用关心上下文是否发生变化，如果每次都使用 context.read<FileBloc>()
            /// 那么在异步操作中，就会报错
            final bloc = context.read<FileBloc>();
            final images = state.files;
            final title = FileDialogTitle(
              editable: state.editable,
              selectedKeys: state.selectedKeys,
              onEditableChanged: (value) => bloc.add(FileEventToggleEditable()),
              onDelete: () => bloc.add(FileEventDelete()),
              onUpload: () => _uploadImages(bloc),
            );
            final content = FileDialogContent(
              images: images,
              editable: state.editable,
              selectedKeys: state.selectedKeys,
              onSelected: (key) => bloc.add(FileEventToggleSelected(key)),
            );
            final actions = [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
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

  Future<void> _uploadImages(FileBloc bloc) async {
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
  }

  List<SingleChildWidget> get _buildBlocProviders {
    return [
      BlocProvider<FileBloc>(
        create: (context) => FileBloc(
          fileRepo: context.read<FileUploadRepository>(),
          fileAdminRepo: context.read<FileAdminRepository>(),
        )..add(FileEventLoad()),
      ),
    ];
  }

  List<SingleChildWidget> get _buildRepositoryProviders {
    return [
      RepositoryProvider<FileUploadRepository>(
        create: (context) => FileUploadRepository(),
      ),
      RepositoryProvider<FileAdminRepository>(
        create: (context) => FileAdminRepository(),
      ),
    ];
  }
}
