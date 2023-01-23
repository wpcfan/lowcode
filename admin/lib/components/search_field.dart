import 'package:admin/constants.dart';
import 'package:admin/controllers/search_field_controller.dart';
import 'package:admin/repositories/github_repository.dart';
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
                return const Iterable<SearchResultItem>.empty();
              }
              await Provider.of<SearchFieldController>(context, listen: false)
                  .query(textEditingValue.text);
              return controller.matched.where((SearchResultItem option) {
                return option.fullName
                    .contains(textEditingValue.text.toLowerCase());
              });
            },
            optionsViewBuilder: (context, onSelected, options) => Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4.0,
                child: SizedBox(
                  height: 200.0,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options.elementAt(index);
                      return GestureDetector(
                        onTap: () {
                          onSelected(option);
                        },
                        child: ListTile(
                          leading: Image.network(
                            option.avatarUrl,
                            width: 40,
                          ),
                          title: Text(option.fullName),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            displayStringForOption: (option) => option.fullName,
            onSelected: (SearchResultItem selection) {
              print('You just selected $selection');
            },
          );
        },
      ),
    );
  }
}
