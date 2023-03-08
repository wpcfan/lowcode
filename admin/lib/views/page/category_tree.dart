import 'package:flutter/material.dart';
import 'package:models/models.dart';

class CategoryTree extends StatefulWidget {
  final List<Category> categories;
  final Function(List<Category> selectedCategories) onSelectionChanged;

  const CategoryTree(
      {super.key, required this.categories, required this.onSelectionChanged});

  @override
  State<CategoryTree> createState() => _CategoryTreeState();
}

class _CategoryTreeState extends State<CategoryTree> {
  final List<Category> _selectedCategories = [];

  @override
  Widget build(BuildContext context) {
    return _buildCategoryTree(widget.categories);
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
    final selected = _selectedCategories.contains(category);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CheckboxListTile(
          title: Text(category.name ?? ''),
          value: selected,
          onChanged: (value) {
            setState(() {
              if (value!) {
                _selectedCategories.add(category);
              } else {
                _selectedCategories.remove(category);
              }
              widget.onSelectionChanged(_selectedCategories);
            });
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
