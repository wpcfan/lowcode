import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';

import 'product_table.dart';

/// 商品数据表单组件
/// [data] 数据
/// [onAdd] 添加商品回调
/// [onRemove] 删除商品回调
class ProductDataForm extends StatefulWidget {
  const ProductDataForm({
    super.key,
    this.onAdd,
    this.onRemove,
    required this.data,
    required this.productRepository,
  });
  final void Function(Product)? onRemove;
  final void Function(Product)? onAdd;
  final List<BlockData<Product>> data;
  final ProductRepository productRepository;

  @override
  State<ProductDataForm> createState() => _ProductDataFormState();
}

class _ProductDataFormState extends State<ProductDataForm> {
  /// 选中的商品
  final List<Product> _selectedProducts = [];

  /// 匹配的商品
  final List<Product> _matchedProducts = [];

  @override
  Widget build(BuildContext context) {
    /// 初始化选中的商品
    setState(() {
      _selectedProducts.clear();
      _selectedProducts.addAll(widget.data.map((e) => e.content));
    });
    return [
      _buildAutocomplete(context),
      const SizedBox(height: 16),
      ProductTable(
        products: _selectedProducts,
        onRemove: widget.onRemove,
      )
    ].toColumn(mainAxisSize: MainAxisSize.min).scrollable();
  }

  Autocomplete<Product> _buildAutocomplete(BuildContext context) {
    return Autocomplete<Product>(
      optionsBuilder: (textValue) async {
        /// 从服务器获取匹配的商品列表
        final matchedProducts = await _searchProducts(textValue.text);
        setState(() {
          _matchedProducts.clear();
          _matchedProducts.addAll(matchedProducts);
        });
        return _matchedProducts;
      },
      optionsViewBuilder: (context, onSelected, options) => Material(
        child: ListView(
          shrinkWrap: true,
          children: options
              .map((e) => ListTile(
                    title: Text(e.name ?? ''),
                    leading: Image.network(
                      e.images.first,
                      fit: BoxFit.cover,
                      width: 40,
                      height: 40,
                    ),
                    onTap: () {
                      onSelected(e);
                    },
                  ))
              .toList(),
        ),
      ),
      onSelected: (option) {
        if (_selectedProducts.length > 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('最多只能选择两个商品'),
            ),
          );
          return;
        }
        setState(() {
          if (!_selectedProducts
              .where((element) => element.id == option.id)
              .isNotEmpty) {
            _selectedProducts.add(option);
            widget.onAdd?.call(option);
          } else {
            _selectedProducts.removeWhere((element) => element.id == option.id);
            widget.onRemove?.call(option);
          }
        });
      },
      displayStringForOption: (option) => option.sku ?? '',
    );
  }

  /// 从服务器获取匹配的商品列表
  /// [text] 搜索关键字
  Future<List<Product>> _searchProducts(String text) async {
    final res = await widget.productRepository.searchByKeyword(text);
    return res;
  }
}
