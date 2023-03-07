import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploader extends StatefulWidget {
  const ImageUploader({super.key});

  @override
  State<ImageUploader> createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  final List<Map<String, dynamic>> _images = [];

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();
    if (pickedImages.isNotEmpty) {
      setState(() {
        _images.addAll(
          pickedImages.map((pickedImage) => {
                'file': File(pickedImage.path),
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _pickImages,
          child: const Text('Pick images'),
        ),
        Expanded(
          child: GridView.builder(
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
                  Image.file(
                    image['file'],
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
        ),
        ElevatedButton(
          onPressed: _deleteSelectedImages,
          child: const Text('Delete selected images'),
        ),
      ],
    );
  }
}
