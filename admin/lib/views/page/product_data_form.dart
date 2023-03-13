import 'package:admin/views/page/product_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:page_repository/page_repository.dart';

class ProductDataForm extends StatefulWidget {
  const ProductDataForm({
    super.key,
    this.onAdd,
    this.onRemove,
    required this.data,
  });
  final void Function(Product)? onRemove;
  final void Function(Product)? onAdd;
  final List<BlockData<Product>> data;

  @override
  State<ProductDataForm> createState() => _ProductDataFormState();
}

class _ProductDataFormState extends State<ProductDataForm> {
  final List<Product> _selectedProducts = [];
  final List<Product> _matchedProducts = [];

  @override
  Widget build(BuildContext context) {
    setState(() {
      _selectedProducts.clear();
      _selectedProducts.addAll(widget.data.map((e) => e.content));
    });
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Autocomplete<Product>(
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
                  _selectedProducts
                      .removeWhere((element) => element.id == option.id);
                  widget.onRemove?.call(option);
                }
              });
            },
            displayStringForOption: (option) => option.sku ?? '',
          ),
          const SizedBox(height: 16),
          ProductTable(
            products: _selectedProducts,
            onRemove: widget.onRemove,
          )
        ],
      ),
    );
  }

  Future<List<Product>> _searchProducts(String text) async {
    final client = context.read<ProductRepository>();
    final res = await client.searchByKeyword(text);
    return res;
  }
}
