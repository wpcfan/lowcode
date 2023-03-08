import 'package:admin/views/page/category_tree.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class CategoryDataForm extends StatelessWidget {
  const CategoryDataForm({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: CategoryTree(
          categories: const [
            Category(name: 'Food', children: [
              Category(name: 'Bread'),
              Category(name: 'Vegetables', children: [
                Category(name: 'Tomatoes'),
                Category(name: 'Potatoes'),
              ]),
              Category(name: 'Fruits', children: [
                Category(name: 'Apples'),
                Category(name: 'Bananas'),
                Category(name: 'Oranges'),
              ]),
            ]),
            Category(name: 'Clothing', children: [
              Category(name: 'Shirts'),
              Category(name: 'Pants'),
              Category(name: 'Shoes'),
            ]),
            Category(name: 'Electronics', children: [
              Category(name: 'Computers'),
              Category(name: 'Smartphones'),
              Category(name: 'Tablets'),
            ]),
          ],
          onSelectionChanged: (categories) {
            for (var category in categories) {
              debugPrint(category.name ?? '');
            }
          }),
    );
  }
}
