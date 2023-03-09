import 'package:flutter/material.dart';
import 'package:models/models.dart';

import 'search_field.dart';

class CategoryTree extends StatefulWidget {
  final List<Category> categories;
  final void Function(Category) onCategoryAdded;
  final void Function(Category) onCategoryRemoved;

  const CategoryTree({
    super.key,
    required this.categories,
    required this.onCategoryAdded,
    required this.onCategoryRemoved,
  });

  @override
  State<CategoryTree> createState() => _CategoryTreeState();
}

class _CategoryTreeState extends State<CategoryTree> {
  final List<Category> _selectedCategories = [];
  final List<Category> _matchedCategories = [];
  @override
  Widget build(BuildContext context) {
    final List<Category> flattenedCategories =
        widget.categories.expand((element) {
      final children = element.children ?? [];
      return [element, ...children];
    }).toList();
    return Column(
      children: [
        SearchField(
          placeholder: '搜索',
          optionsBuilder: (text) {
            final matched = flattenedCategories
                .where((element) =>
                    element.name!.toLowerCase().contains(text.toLowerCase()))
                .toList();
            setState(() {
              _matchedCategories.clear();
              _matchedCategories.addAll(matched);
            });
            return _matchedCategories
                .map((e) => SearchOption(name: e.name, value: e))
                .toList();
          },
          itemBuilder: (context, index, onSelected) {
            final category = _matchedCategories[index];
            return ListTile(
              title: Text(category.name ?? ''),
              onTap: () {
                onSelected(SearchOption(name: category.name!, value: category));
              },
            );
          },
          onSelected: (option) {
            setState(() {
              if (_selectedCategories.contains(option.value)) {
                _selectedCategories.remove(option.value);
                widget.onCategoryRemoved(option.value);
              } else {
                _selectedCategories.add(option.value);
                widget.onCategoryAdded(option.value);
              }
            });
          },
        ),
        _buildCategoryTree(widget.categories),
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
                widget.onCategoryAdded(category);
              } else {
                _selectedCategories.remove(category);
                widget.onCategoryRemoved(category);
              }
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
