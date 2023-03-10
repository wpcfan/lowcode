import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_repository/page_repository.dart';

class ImageUploader extends StatefulWidget {
  const ImageUploader({
    super.key,
    required this.onImagesSubmitted,
    required this.onError,
    this.maxImages = 9,
  });
  final void Function(List<UploadFile> images) onImagesSubmitted;
  final void Function(String) onError;
  final int maxImages;

  @override
  State<ImageUploader> createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  final List<Map<String, dynamic>> _images = [];

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();
    if (pickedImages.length > widget.maxImages) {
      widget.onError('你最多只能一次选取 ${widget.maxImages} 张图片');
      return;
    }
    if (pickedImages.isNotEmpty) {
      setState(() {
        _images.addAll(
          pickedImages.map((pickedImage) => {
                'path': pickedImage.path,
                'file': pickedImage,
                'name': pickedImage.name,
                'isSelected': false,
              }),
        );
      });
    }
  }

  void _toggleImageSelection(int index) {
    setState(() {
      _images[index]['isSelected'] = !_images[index]['isSelected'];
    });
  }

  void _deleteSelectedImages() {
    setState(() {
      _images.removeWhere((image) => image['isSelected']);
    });
  }

  Future<Uint8List> fileToFile(XFile file) async {
    final bytes = await file.readAsBytes();
    return bytes;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _pickImages,
          child: const Text('Pick images'),
        ),
        GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: _images.length,
          itemBuilder: (context, index) {
            final image = _images[index];
            return Stack(
              children: [
                Image.network(
                  image['path'],
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    onPressed: () => _toggleImageSelection(index),
                    icon: Icon(
                      image['isSelected']
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        Row(
          children: [
            ElevatedButton(
              onPressed: _deleteSelectedImages,
              child: const Text('Delete selected images'),
            ),
            ElevatedButton(
              onPressed: () async {
                final List<UploadFile> selectedImages = [];
                for (final image in _images) {
                  if (image['isSelected']) {
                    selectedImages.add(UploadFile(
                        name: image['name'],
                        file: await fileToFile(image['file'])));
                  }
                }
                widget.onImagesSubmitted(selectedImages);
              },
              child: const Text('Save'),
            ),
          ],
        )
      ],
    );
  }
}
