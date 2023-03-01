import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

import 'image.dart';

class ImageRowWidget extends StatelessWidget {
  const ImageRowWidget({
    super.key,
    required this.items,
    required this.config,
    required this.ratio,
    required this.errorImage,
    this.onTap,
  });
  final List<ImageData> items;
  final BlockConfig config;
  final double ratio;
  final String errorImage;
  final void Function(MyLink?)? onTap;

  @override
  Widget build(BuildContext context) {
    final blockWidth = (config.blockWidth ?? 0) / ratio;
    final blockHeight = (config.blockHeight ?? 0) / ratio;
    final horizontalPadding = (config.horizontalPadding ?? 0) / ratio;
    final verticalPadding = (config.verticalPadding ?? 0) / ratio;
    final itemWidth = blockWidth - horizontalPadding * 2;
    final itemHeight = blockHeight - verticalPadding * 2;
    page({required Widget child}) => SwiftUi.widget(child: child)
        .padding(horizontal: horizontalPadding, vertical: verticalPadding)
        .constrained(maxWidth: blockWidth, maxHeight: blockHeight)
        .border(all: 1, color: Colors.grey);
    switch (items.length) {
      case 0: // Empty
        return page(child: const Placeholder());
      case 1:
        return _buildSingleImage(context, itemWidth, itemHeight).parent(page);
      case 2:
      case 3:
        return _buildImages(context, itemWidth).parent(page);
      default:
        return _buildScrollableImages(context, itemWidth, itemHeight)
            .parent(page);
    }
  }

  Widget _buildSingleImage(
      BuildContext context, double blockWidth, double blockHeight) {
    final item = items.first;
    return SizedBox(
      width: blockWidth,
      height: blockHeight,
      child: ImageWidget(
        imageUrl: item.image,
        errorImage: errorImage,
        link: item.link,
        onTap: onTap,
      ),
    );
  }

  Widget _buildImages(BuildContext context, double width) {
    final spaceBetweenItems = (config.horizontalSpacing ?? 0) / ratio;
    return Row(
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
    );
  }

  Widget _buildScrollableImages(
      BuildContext context, double blockWidth, double itemHeight) {
    final itemWidth = blockWidth / 3;
    final spaceBetweenItems = (config.horizontalSpacing ?? 0) / ratio;
    return ListView(
      scrollDirection: Axis.horizontal,
      itemExtent: itemWidth,
      children: items
          .mapWithIndex(
            (item, index) => Container(
              width: itemWidth - spaceBetweenItems * 2,
              height: itemHeight,
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
    );
  }
}
