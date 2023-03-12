import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:page_repository/page_repository.dart';

import '../../blocs/category_bloc.dart';
import '../../blocs/category_event.dart';

class CategoryDataForm extends StatefulWidget {
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
  State<CategoryDataForm> createState() => _CategoryDataFormState();
}

class _CategoryDataFormState extends State<CategoryDataForm> {
  Category? _selectedCategory;
  @override
  Widget build(BuildContext context) {
    final categoryRepository = context.read<CategoryRepository>();
    context.read<CategoryBloc>().add(const CategoryEventLoad());

    return SingleChildScrollView(
        child: FutureBuilder(
      future: _getCategories(categoryRepository),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (widget.data.isNotEmpty) {
          _selectedCategory = widget.data.first.content;
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
            if (widget.data
                .where((element) => element.content.id == option.id)
                .isNotEmpty) {
              setState(() {
                _selectedCategory = null;
              });
              widget.onCategoryRemoved(option);
            } else {
              if (_selectedCategory == null) {
                setState(() {
                  _selectedCategory = option;
                });
                widget.onCategoryAdded(option);
                return;
              }
              setState(() {
                _selectedCategory = option;
              });
              widget.onCategoryUpdated(option);
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
          groupValue: _selectedCategory,
          onChanged: (value) {
            if (value != null) {
              if (_selectedCategory != null) {
                setState(() {
                  _selectedCategory = value;
                });
                widget.onCategoryUpdated(value);
                return;
              }
              setState(() {
                _selectedCategory = value;
              });
              widget.onCategoryAdded(category);
            } else {
              setState(() {
                _selectedCategory = null;
              });
              widget.onCategoryRemoved(category);
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
