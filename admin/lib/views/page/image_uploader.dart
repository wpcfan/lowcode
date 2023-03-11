import 'package:admin/blocs/flie_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_repository/page_repository.dart';

import '../../blocs/file_bloc.dart';
import '../../blocs/file_state.dart';

class ImageUploader extends StatelessWidget {
  const ImageUploader({
    super.key,
    required this.onError,
    required this.bloc,
    this.maxImages = 9,
  });
  final void Function(String) onError;
  final int maxImages;
  final FileBloc bloc;

  Future<void> _pickImages(FileBloc bloc) async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();
    if (pickedImages.length > maxImages) {
      onError('你最多只能一次选取 $maxImages 张图片');
      return;
    }
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FileBloc, FileState>(
      bloc: bloc,
      builder: (context, state) {
        if (state.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.error.isNotEmpty) {
          return Text(state.error);
        }
        return Column(
          children: [
            ElevatedButton(
              onPressed: state.uploading
                  ? null
                  : () async {
                      await _pickImages(bloc);
                    },
              child:
                  state.uploading ? const Text('上传中...') : const Text('上传图片'),
            ),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: state.files.length,
              itemBuilder: (context, index) {
                final image = state.files[index];
                return Stack(
                  children: [
                    Image.network(
                      image.url,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          bloc.add(FileEventDelete(image.key));
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }
}
