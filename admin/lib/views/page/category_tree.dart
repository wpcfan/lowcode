import 'package:flutter/material.dart';
import 'package:models/models.dart';

import 'search_field.dart';

class CategoryTree extends StatelessWidget {
  final List<Category> categories;
  final List<Category> matchedCategories;
  final List<Category> selectedCategories;
  final void Function(Category) onCategoryAdded;
  final void Function(Category) onCategoryRemoved;
  final void Function(String) onTextChanged;

  const CategoryTree({
    super.key,
    required this.categories,
    required this.matchedCategories,
    required this.selectedCategories,
    required this.onCategoryAdded,
    required this.onCategoryRemoved,
    required this.onTextChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchField(
          placeholder: '搜索',
          optionsBuilder: (text) {
            return matchedCategories
                .map((e) => SearchOption(name: e.name, value: e))
                .toList();
          },
          itemBuilder: (context, index, onSelected) {
            final category = matchedCategories[index];
            return ListTile(
              title: Text(category.name ?? ''),
              onTap: () {
                onSelected(SearchOption(name: category.name!, value: category));
              },
            );
          },
          onSelected: (option) {
            if (selectedCategories.contains(option.value)) {
              onCategoryRemoved(option.value);
            } else {
              onCategoryAdded(option.value);
            }
          },
          onTextChanged: onTextChanged,
        ),
        _buildCategoryTree(categories),
      ],
    );
  }

  Widget _buildCategoryTree(List<Category> categories) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final category = categories[index];
        return _buildCategoryItem(category);
      },
      itemCount: categories.length,
    );
  }

  Widget _buildCategoryItem(Category category) {
    final selected = selectedCategories.contains(category);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CheckboxListTile(
          title: Text(category.name ?? ''),
          value: selected,
          onChanged: (value) {
            if (value!) {
              onCategoryAdded(category);
            } else {
              onCategoryRemoved(category);
            }
          },
        ),
        if (category.children != null)
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: _buildCategoryTree(category.children!),
          ),
      ],
    );
  }
}
