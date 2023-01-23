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
          return PopupMenuButton(
            child: TextField(
              onChanged: (value) {
                Provider.of<SearchFieldController>(context, listen: false)
                    .query(value);
              },
              decoration: InputDecoration(
                hintText: "Search",
                fillColor: secondaryColor,
                filled: true,
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                suffixIcon: InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(defaultPadding * 0.75),
                    margin: const EdgeInsets.symmetric(
                        horizontal: defaultPadding / 2),
                    decoration: const BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: const Icon(Icons.search),
                  ),
                ),
              ),
            ),
            itemBuilder: (context) {
              final matched = controller.matched;
              return matched
                  .map((e) => PopupMenuItem(
                        child: Text(e),
                      ))
                  .toList();
            },
          );
        },
      ),
    );
  }
}
