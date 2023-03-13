import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:page_repository/page_repository.dart';

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
    final categoryRepository = context.read<CategoryRepository>();

    return SingleChildScrollView(
        child: FutureBuilder(
      future: _getCategories(categoryRepository),
      initialData: const [],
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.data == null || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data'));
        }

        final categories = snapshot.data as List<Category>;

        return Autocomplete<Category>(
          optionsBuilder: (text) {
            return categories
                .where((element) => element.name!
                    .toLowerCase()
                    .contains(text.text.toLowerCase()))
                .toList();
          },
          optionsViewBuilder: (context, onSelected, options) {
            return _buildCategoryTree(options);
          },
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
          displayStringForOption: (option) => option.name ?? '',
        );
      },
    ));
  }

  Future<List<Category>> _getCategories(
      CategoryRepository categoryRepository) async {
    final categories = await categoryRepository.getCategories();
    return categories;
  }

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

  Widget _buildCategoryItem(Category category) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
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
        if (category.children != null && category.children!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: _buildCategoryTree(category.children!),
          ),
      ],
    );
  }
}
