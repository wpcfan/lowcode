import 'package:flutter/material.dart';
import 'package:models/models.dart';

import 'category_data_form.dart';
import 'image_data_form.dart';
import 'product_data_form.dart';

/// 用于不同区块数据的表单的容器
/// [block] 区块
/// [onCategoryAdded] 类目添加回调
/// [onCategoryUpdated] 类目更新回调
/// [onCategoryRemoved] 类目移除回调
/// [onProductAdded] 商品添加回调
/// [onProductRemoved] 商品移除回调
/// [onImageAdded] 图片添加回调
/// [onImageRemoved] 图片移除回调
class BlockDataPane extends StatelessWidget {
  const BlockDataPane({
    super.key,
    required this.block,
    required this.onCategoryAdded,
    required this.onCategoryUpdated,
    required this.onCategoryRemoved,
    required this.onProductAdded,
    required this.onProductRemoved,
    required this.onImageAdded,
    required this.onImageRemoved,
  });
  final PageBlock block;
  final void Function(Category) onCategoryAdded;
  final void Function(Category) onCategoryUpdated;
  final void Function(Category) onCategoryRemoved;
  final void Function(Product) onProductAdded;
  final void Function(Product) onProductRemoved;
  final void Function(ImageData) onImageAdded;
  final void Function(int) onImageRemoved;

  @override
  Widget build(BuildContext context) {
    /// 根据区块类型返回不同的表单
    switch (block.type) {
      /// Banner 区块
      case PageBlockType.banner:

      /// 图片区块
      case PageBlockType.imageRow:
        return ImageDataForm(
          data: block.data.map((e) => e as BlockData<ImageData>).toList(),
          onImageAdded: onImageAdded,
          onImageRemoved: onImageRemoved,
        );

      /// 商品区块
      case PageBlockType.productRow:
        return ProductDataForm(
          data: block.data.map((e) => e as BlockData<Product>).toList(),
          onAdd: onProductAdded,
          onRemove: onProductRemoved,
        );

      /// 瀑布流区块
      case PageBlockType.waterfall:
        return CategoryDataForm(
          data: block.data.map((e) => e as BlockData<Category>).toList(),
          onCategoryAdded: onCategoryAdded,
          onCategoryUpdated: onCategoryUpdated,
          onCategoryRemoved: onCategoryRemoved,
        );
      default:
        return const SizedBox();
    }
  }
}
