import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

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
  });
  final List<ImageData> items;
  final double itemWidth;
  final double itemHeight;
  final double verticalPadding;
  final double horizontalPadding;
  final double spaceBetweenItems;
  final String errorImage;

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
    return InkWell(
      onTap: () {
        if (item.link != null) {
          Navigator.of(context).pushNamed(
            item.link!.value,
          );
        }
      },
      child: Container(
        width: itemWidth,
        height: itemHeight,
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizontalPadding,
        ),
        child: ImageWidget(
          imageUrl: item.image,
          width: itemWidth - horizontalPadding * 2,
          height: itemHeight - verticalPadding * 2,
          errorImage: errorImage,
        ),
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
                child: InkWell(
                  onTap: () {
                    if (item.link != null) {
                      Navigator.of(context).pushNamed(
                        item.link!.value,
                      );
                    }
                  },
                  child: ImageWidget(
                    imageUrl: item.image,
                    width: double.infinity,
                    height: double.infinity,
                    errorImage: errorImage,
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
        children: items
            .mapWithIndex(
              (item, index) => InkWell(
                onTap: () {
                  if (item.link != null) {
                    Navigator.of(context).pushNamed(
                      item.link!.value,
                    );
                  }
                },
                child: Container(
                  width: itemWidth - horizontalPadding * 2,
                  height: itemHeight - verticalPadding * 2,
                  margin: EdgeInsets.only(
                    right: index == items.length - 1 ? 0 : spaceBetweenItems,
                  ),
                  child: ImageWidget(
                    imageUrl: item.image,
                    width: double.infinity,
                    height: double.infinity,
                    errorImage: errorImage,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
