import 'package:flutter/material.dart';
import 'package:models/models.dart';

class ProductTable extends StatelessWidget {
  const ProductTable({
    super.key,
    required this.products,
    this.onRemove,
  });
  final List<Product> products;
  final void Function(Product)? onRemove;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('商品SKU')),
        DataColumn(label: Text('商品名称')),
        DataColumn(label: Text('商品图片')),
        DataColumn(label: Text('商品价格')),
        DataColumn(label: Text('操作')),
      ],
      rows: products
          .map((e) => DataRow(
                cells: [
                  DataCell(Text(e.sku ?? '')),
                  DataCell(Text(e.name ?? '')),
                  DataCell(Image.network(
                    e.images.first,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  )),
                  DataCell(Text(e.price.toString())),
                  DataCell(IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => onRemove?.call(e),
                  )),
                ],
              ))
          .toList(),
    );
  }
}
