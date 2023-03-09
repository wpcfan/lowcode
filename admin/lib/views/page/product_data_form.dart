import 'dart:async';

import 'package:admin/views/page/product_table.dart';
import 'package:admin/views/page/search_field.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';

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
          SearchField(
            optionsBuilder: (text) async {
              /// 从服务器获取匹配的商品列表
              final matchedProducts = await _searchProducts(text);
              setState(() {
                _matchedProducts.clear();
                _matchedProducts.addAll(matchedProducts);
              });

              /// 将匹配的商品列表转换为 SearchFieldOption 列表
              return matchedProducts
                  .map((e) => SearchOption(name: e.name, value: e))
                  .toList();
            },
            itemBuilder: (context, index, onSelected) {
              final product = _matchedProducts[index];

              /// 构建商品列表项
              return ListTile(
                dense: false,
                title: Text(product.name ?? ''),
                leading: Image.network(
                  product.images.first,
                  fit: BoxFit.cover,
                  width: 40,
                  height: 40,
                ),
                trailing: Text(product.price.toString()),
                onTap: () {
                  onSelected(SearchOption(name: product.name!, value: product));
                },
              );
            },
            onSelected: (option) {
              /// 将选中的商品添加到已选商品列表中
              setState(() {
                final product = option.value as Product;
                if (!_selectedProducts
                    .where((element) => element.id == product.id)
                    .isNotEmpty) {
                  _selectedProducts.add(product);
                  widget.onAdd?.call(product);
                }
              });
            },
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
    final client = context.read<Dio>();
    final res = await client.get('/products/by-example', queryParameters: {
      'keyword': text,
    });
    final result = PageWrapper<Product>.fromJson(
        res.data, (json) => Product.fromJson(json));

    return result.items;
  }
}
