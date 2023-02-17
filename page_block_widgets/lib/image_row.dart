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
    final screenWidth = MediaQuery.of(context).size.width;
    final width = screenWidth - horizontalPadding * 2;
    switch (items.length) {
      case 1:
        return _buildSingleImage(context, width);
      case 2:
      case 3:
        return _buildImages(context, width);
      default:
        return _buildScrollableImages(context, width);
    }
  }

  Widget _buildSingleImage(BuildContext context, double width) {
    final item = items.first;
    return Container(
      width: itemWidth > 0 ? itemWidth : width,
      height: itemHeight > 0 ? itemHeight : null,
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

  Widget _buildImages(BuildContext context, double width) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
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

  Widget _buildScrollableImages(BuildContext context, double width) {
    final liItemWidth = itemWidth > 0 ? itemWidth : width / 3;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        itemExtent: liItemWidth,
        children: items
            .mapWithIndex(
              (item, index) => Container(
                width: liItemWidth - horizontalPadding * 2,
                height:
                    itemHeight > 0 ? itemHeight - verticalPadding * 2 : null,
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
