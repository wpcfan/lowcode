import 'package:admin/views/page/category_tree.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';

import '../../blocs/category_bloc.dart';
import '../../blocs/category_event.dart';
import '../../blocs/category_state.dart';

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
    context.read<CategoryBloc>().add(const CategoryEventLoad());
    return SingleChildScrollView(
        child: BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.categories.isEmpty) {
          return const Center(child: Text('暂无分类'));
        }

        if (state.error.isNotEmpty) {
          return Center(child: Text(state.error));
        }

        return CategoryTree(
          categories: state.categories,
          matchedCategories: state.matchedCategories,
          selectedCategories: data.map((e) => e.content).toList(),
          onCategoryAdded: onCategoryAdded,
          onCategoryRemoved: onCategoryRemoved,
          onTextChanged: (keyword) {
            context.read<CategoryBloc>().add(CategoryEventSearch(keyword));
          },
        );
      },
    ));
  }
}
