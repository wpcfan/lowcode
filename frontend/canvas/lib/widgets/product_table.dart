import 'package:flutter/material.dart';
import 'package:models/models.dart';

/// 商品表格组件
/// [products] 商品列表
/// [onRemove] 删除回调
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
    const columns = [
      DataColumn(label: Text('商品SKU')),
      DataColumn(label: Text('商品名称')),
      DataColumn(label: Text('商品图片')),
      DataColumn(label: Text('商品价格')),
      DataColumn(label: Text('操作')),
    ];
    return DataTable(
      columns: columns,
      rows: products.map((e) => DataRow(cells: _buildCells(e))).toList(),
    );
  }

  List<DataCell> _buildCells(Product e) {
    return [
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
    ];
  }
}
