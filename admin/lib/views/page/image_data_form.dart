import 'package:admin/views/page/image_uploader.dart';
import 'package:flutter/material.dart';

class ImageDataForm extends StatelessWidget {
  const ImageDataForm({super.key});

  @override
  Widget build(BuildContext context) {
    return ImageUploader(
      onImagesSubmitted: (images) {
        for (var image in images) {
          debugPrint(image.toString());
        }
      },
      onError: (error) {
        debugPrint(error);
      },
      maxImages: 9,
    );
  }
}
