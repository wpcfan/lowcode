import 'package:common/extensions/all.dart';
import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({
    super.key,
    required this.image,
    required this.width,
    required this.height,
    this.radius = 0,
  });
  final String image;
  final double width;
  final double height;
  final double radius;
  @override
  Widget build(BuildContext context) {
    return Image.network(
      image,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        debugPrint('error: $error');
        return Image.asset('images/100x100.png');
      },
    ).clipRRect(all: radius);
  }
}
