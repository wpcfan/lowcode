import 'package:admin/constants.dart';
import 'package:admin/controllers/search_field_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchFieldController>(
      create: (context) => SearchFieldController(),
      child: Consumer<SearchFieldController>(
        builder: (context, controller, child) {
          return Autocomplete(
            fieldViewBuilder:
                (context, textEditingController, focusNode, onFieldSubmitted) =>
                    TextField(
              controller: textEditingController,
              focusNode: focusNode,
              decoration: const InputDecoration(
                hintText: "Search",
                fillColor: secondaryColor,
                filled: true,
                isDense: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                suffixIcon: Icon(
                  Icons.search,
                  size: 24,
                ),
              ),
            ),
            optionsBuilder: (TextEditingValue textEditingValue) async {
              if (textEditingValue.text == '') {
                return const Iterable<String>.empty();
              }
              await Provider.of<SearchFieldController>(context, listen: false)
                  .query(textEditingValue.text);
              return controller.matched.where((String option) {
                return option.contains(textEditingValue.text.toLowerCase());
              });
            },
            onSelected: (String selection) {
              print('You just selected $selection');
            },
          );
        },
      ),
    );
  }
}
