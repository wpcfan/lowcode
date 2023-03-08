import 'package:flutter/material.dart';
import 'package:models/models.dart';

import 'category_data_form.dart';
import 'image_data_form.dart';
import 'product_data_form.dart';

class BlockDataPane extends StatelessWidget {
  const BlockDataPane(
      {super.key, required this.block, required this.onCategoryChanged});
  final PageBlock block;
  final void Function(List<Category> selectedCategories) onCategoryChanged;

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
        return CategoryDataForm(
          onSelectionChanged: onCategoryChanged,
        );
      default:
        return const SizedBox();
    }
  }
}
