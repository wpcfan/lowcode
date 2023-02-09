import 'package:common/common.dart';
import 'package:common/config.dart';
import 'package:common/models/all.dart';
import 'package:flutter/material.dart';

class ImageRowWidget extends StatelessWidget {
  const ImageRowWidget({super.key, required this.pageBlock});
  final ImageRowPageBlock pageBlock;

  @override
  Widget build(BuildContext context) {
    final aspectRatio = pageBlock.width! / pageBlock.height!;
    final width =
        MediaQuery.of(context).size.width - screenHorizontalPadding * 2;
    final height = width / aspectRatio;
    return Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: listHorizontalPadding,
            vertical: spaceBetweenListItems / 2),
        child: SizedBox(
          height: height,
          child: pageBlock.data
              .map((el) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () => debugPrint('on tap ${el.link}'),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(el.image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              })
              .toList()
              .toRow(),
        ));
  }
}
