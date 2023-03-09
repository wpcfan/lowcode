import 'package:admin/views/page/category_tree.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';

class CategoryDataForm extends StatelessWidget {
  const CategoryDataForm({
    super.key,
    required this.onCategoryAdded,
    required this.onCategoryRemoved,
    required this.data,
  });
  final void Function(Category) onCategoryAdded;
  final void Function(Category) onCategoryRemoved;
  final List<BlockData<Category>> data;

  @override
  Widget build(BuildContext context) {
    final client = context.read<Dio>();
    return SingleChildScrollView(
      child: FutureBuilder(
          future: client.get('/categories'),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            final res = snapshot.data;
            if (res == null || res.data == null || res.data is! List) {
              return const Text('没有分类数据');
            }

            /// 从响应数据中解析出分类列表
            /// 由于响应数据中的分类数据是 Map<String, dynamic> 类型的
            /// 所以需要将其转换为 Category 类型
            /// 注意 List<dynamic> 不能直接转换为 List<Category>
            /// 所以需要使用 List.from() 方法
            final categories = List<Category>.from(res.data
                .map((e) => Category.fromJson(e as Map<String, dynamic>)));

            return CategoryTree(
              categories: categories,
              onCategoryAdded: onCategoryAdded,
              onCategoryRemoved: onCategoryRemoved,
            );
          }),
    );
  }
}
