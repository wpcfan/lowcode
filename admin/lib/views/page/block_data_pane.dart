import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:models/models.dart';

import 'category_data_form.dart';
import 'image_data_form.dart';
import 'product_data_form.dart';

class BlockDataPane extends StatelessWidget {
  const BlockDataPane({
    super.key,
    required this.block,
    required this.onCategoryAdded,
    required this.onCategoryRemoved,
    required this.onProductAdded,
    required this.onProductRemoved,
    required this.onImagesSubmitted,
  });
  final PageBlock block;
  final void Function(Category) onCategoryAdded;
  final void Function(Category) onCategoryRemoved;
  final void Function(Product) onProductAdded;
  final void Function(Product) onProductRemoved;
  final void Function(List<Uint8List>) onImagesSubmitted;

  @override
  Widget build(BuildContext context) {
    switch (block.type) {
      case PageBlockType.banner:
      case PageBlockType.imageRow:
        return ImageDataForm(
          data: block.data.map((e) => e as BlockData<ImageData>).toList(),
        );
      case PageBlockType.productRow:
        return ProductDataForm(
          data: block.data.map((e) => e as BlockData<Product>).toList(),
          onAdd: onProductAdded,
          onRemove: onProductRemoved,
        );
      case PageBlockType.waterfall:
        return CategoryDataForm(
          data: block.data.map((e) => e as BlockData<Category>).toList(),
          onCategoryAdded: onCategoryAdded,
          onCategoryRemoved: onCategoryRemoved,
        );
      default:
        return const SizedBox();
    }
  }
}
