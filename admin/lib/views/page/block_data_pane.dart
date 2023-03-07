import 'package:flutter/material.dart';
import 'package:models/models.dart';

import 'category_data_form.dart';
import 'image_data_form.dart';
import 'product_data_form.dart';

class BlockDataPane extends StatelessWidget {
  const BlockDataPane({super.key, required this.block});
  final PageBlock block;

  @override
  Widget build(BuildContext context) {
    switch (block.type) {
      case PageBlockType.banner:
        return const ImageDataForm();
      case PageBlockType.imageRow:
        return const ImageDataForm();
      case PageBlockType.productRow:
        return const ProductDataForm();
      case PageBlockType.waterfall:
        return const CategoryDataForm();
      default:
        return const SizedBox();
    }
  }
}
