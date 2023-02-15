import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

import 'image.dart';

class ImageRowWidget extends StatelessWidget {
  const ImageRowWidget({
    super.key,
    required this.items,
    required this.itemWidth,
    required this.itemHeight,
    required this.verticalPadding,
    required this.horizontalPadding,
    required this.spaceBetweenItems,
    required this.errorImage,
    this.onTap,
  });
  final List<ImageData> items;
  final double itemWidth;
  final double itemHeight;
  final double verticalPadding;
  final double horizontalPadding;
  final double spaceBetweenItems;
  final String errorImage;
  final void Function(MyLink?)? onTap;

  @override
  Widget build(BuildContext context) {
    switch (items.length) {
      case 1:
        return _buildSingleImage(context);
      case 2:
      case 3:
        return _buildImages(context);
      default:
        return _buildScrollableImages(context);
    }
  }

  Widget _buildSingleImage(BuildContext context) {
    final item = items.first;
    return Container(
      width: itemWidth,
      height: itemHeight,
      padding: EdgeInsets.symmetric(
        vertical: verticalPadding,
        horizontal: horizontalPadding,
      ),
      child: ImageWidget(
        imageUrl: item.image,
        errorImage: errorImage,
        link: item.link,
        onTap: onTap,
      ),
    );
  }

  Widget _buildImages(BuildContext context) {
    return Container(
      width: itemWidth,
      height: itemHeight,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items
            .mapWithIndex(
              (item, index) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: index == items.length - 1 ? 0 : spaceBetweenItems,
                  ),
                  child: ImageWidget(
                    imageUrl: item.image,
                    errorImage: errorImage,
                    link: item.link,
                    onTap: onTap,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildScrollableImages(BuildContext context) {
    return Container(
      width: itemWidth,
      height: itemHeight,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        itemExtent: itemWidth,
        children: items
            .mapWithIndex(
              (item, index) => Container(
                width: itemWidth - horizontalPadding * 2,
                height: itemHeight - verticalPadding * 2,
                margin: EdgeInsets.only(
                  right: index == items.length - 1 ? 0 : spaceBetweenItems,
                ),
                child: ImageWidget(
                  imageUrl: item.image,
                  errorImage: errorImage,
                  link: item.link,
                  onTap: onTap,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
