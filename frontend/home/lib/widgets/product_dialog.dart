import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

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
      child: SizedBox(
        width: 300,
        height: 400,
        child: Column(
          children: [
            Expanded(
              child: Image.network(
                product.images.first,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(errorImage);
                },
              ).padding(top: 12),
            ),
            Text(product.name!),
            Text(product.price!),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Add to cart'),
            ),
          ],
        ),
      ),
    );
  }
}
