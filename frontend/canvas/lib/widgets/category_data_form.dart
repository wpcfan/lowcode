import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';

/// 用于类目数据的表单
/// [onCategoryAdded] 类目添加回调
/// [onCategoryUpdated] 类目更新回调
/// [onCategoryRemoved] 类目移除回调
/// [data] 类目数据
class CategoryDataForm extends StatelessWidget {
  const CategoryDataForm({
    super.key,
    required this.onCategoryAdded,
    required this.onCategoryUpdated,
    required this.onCategoryRemoved,
    required this.data,
  });
  final void Function(Category) onCategoryAdded;
  final void Function(Category) onCategoryUpdated;
  final void Function(Category) onCategoryRemoved;
  final List<BlockData<Category>> data;

  @override
  Widget build(BuildContext context) {
    /// 类目仓库
    final categoryRepository = context.read<CategoryRepository>();

    return FutureBuilder(
      future: _getCategories(categoryRepository),
      initialData: const [],
      builder: (context, snapshot) {
        /// 加载中
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        /// 错误
        if (snapshot.hasError) {
          return Text('错误: ${snapshot.error}');
        }

        /// 没有数据
        if (snapshot.data == null || snapshot.data!.isEmpty) {
          return const Center(child: Text('没有数据'));
        }

        /// 类目
        final categories = snapshot.data as List<Category>;

        final autoComplete = Autocomplete<Category>(
          /// 构建选项
          optionsBuilder: (text) {
            return categories
                .where((element) => element.name!
                    .toLowerCase()
                    .contains(text.text.toLowerCase()))
                .toList();
          },

          /// 选中回调
          onSelected: (option) {
            if (data
                .where((element) => element.content.id == option.id)
                .isNotEmpty) {
              onCategoryRemoved(option);
            } else {
              if (data.isEmpty) {
                onCategoryAdded(option);
                return;
              }
              onCategoryUpdated(option);
            }
          },

          /// 选中值在输入框中的显示
          displayStringForOption: (option) => option.name ?? '',
        );
        final tree = _buildCategoryTree(categories);
        return [autoComplete, tree]
            .toColumn(mainAxisSize: MainAxisSize.min)
            .scrollable();
      },
    );
  }

  /// 获取类目
  Future<List<Category>> _getCategories(
      CategoryRepository categoryRepository) async {
    final categories = await categoryRepository.getCategories();
    return categories;
  }

  /// 构建类目树
  Widget _buildCategoryTree(Iterable<Category> categories) {
    return Material(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final category = categories.elementAt(index);
          return _buildCategoryItem(category);
        },
        itemCount: categories.length,
      ),
    );
  }

  /// 构建类目项
  Widget _buildCategoryItem(Category category) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// 类目
        RadioListTile(
          title: Text(category.name ?? ''),
          value: category,
          selected: data.isEmpty ? false : data.first.content.id == category.id,
          groupValue: data.isEmpty ? null : data.first.content,
          onChanged: (value) {
            if (value != null) {
              if (data.isNotEmpty) {
                onCategoryUpdated(value);
                return;
              }
              onCategoryAdded(category);
            } else {
              onCategoryRemoved(category);
            }
          },
        ),

        /// 子类目
        if (category.children != null && category.children!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: _buildCategoryTree(category.children!),
          ),
      ],
    );
  }
}
