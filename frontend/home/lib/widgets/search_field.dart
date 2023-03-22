import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 顶部导航栏的标题位置组件
class SearchFieldWidget extends StatelessWidget {
  const SearchFieldWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const CupertinoSearchTextField(
      placeholder: '搜索商品',
      placeholderStyle: TextStyle(color: Colors.white30),
      prefixIcon: Icon(Icons.search, color: Colors.white),
      backgroundColor: Colors.black12,
      style: TextStyle(color: Colors.white),
    );
  }
}
