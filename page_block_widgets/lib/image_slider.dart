import 'package:carousel_slider/carousel_slider.dart';
import 'package:demo/models/all.dart';
import 'package:flutter/material.dart';

class ImageSliderWidget extends StatelessWidget {
  const ImageSliderWidget({super.key, required this.pageBlock});
  final SliderPageBlock pageBlock;

  @override
  Widget build(BuildContext context) {
    final aspectRatio = (pageBlock.width ?? 400) / (pageBlock.height ?? 150);
    final padding = MediaQuery.of(context).padding.left +
        MediaQuery.of(context).padding.right;
    final width = MediaQuery.of(context).size.width - padding;
    final height = width / aspectRatio;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: CarouselSlider(
        options: CarouselOptions(
          height: height,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          scrollDirection: Axis.horizontal,
        ),
        items: pageBlock.data.map((el) {
          return Builder(
            builder: (BuildContext context) {
              return GestureDetector(
                onTap: () {
                  debugPrint('link: ${el.link}');
                },
                child: Container(
                  width: width,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: const BoxDecoration(
                    color: Colors.amber,
                  ),
                  child: Image.network(
                    el.image,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
