import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:page_block_widgets/page_block_widgets.dart';

/// 用来显示商品的对话框
class ProductDialog extends StatelessWidget {
  const ProductDialog({
    super.key,
    required this.product,
    required this.errorImage,
  });
  final Product product;
  final String errorImage;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: [
        ImageWidget(
          imageUrl: product.images.first,
          errorImage: errorImage,
        ).padding(top: 12).expanded(),
        Text(product.name!),
        Text(product.price!),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('加入购物车'),
        ),
      ].toColumn().constrained(maxWidth: 300, maxHeight: 400),
    );
  }
}
