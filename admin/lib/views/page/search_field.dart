import 'dart:async';

import 'package:flutter/material.dart';

class SearchOption {
  const SearchOption({
    this.name,
    this.value,
  });

  final String? name;
  final dynamic value;
}

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    this.placeholder = '搜索',
    this.suffixIcon = const Icon(
      Icons.search,
      size: 24,
    ),
    this.fillColor = Colors.grey,
    this.matchedOptions = const [],
    required this.optionsBuilder,
    required this.itemBuilder,
    required this.onSelected,
  });
  final String placeholder;
  final Widget? suffixIcon;
  final Color fillColor;
  final List<SearchOption> matchedOptions;
  final FutureOr<Iterable<SearchOption>> Function(String) optionsBuilder;
  final Widget Function(
      BuildContext, int, void Function(SearchOption) onSelected) itemBuilder;
  final void Function(SearchOption) onSelected;

  @override
  Widget build(BuildContext context) {
    return Autocomplete(
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) =>
              TextField(
        controller: textEditingController,
        focusNode: focusNode,
        decoration: InputDecoration(
          hintText: placeholder,
          fillColor: fillColor,
          filled: true,
          isDense: true,
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          suffixIcon: suffixIcon,
        ),
      ),
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<SearchOption>.empty();
        }
        return optionsBuilder(textEditingValue.text);
      },
      optionsViewBuilder: (context, onSelected, options) =>
          SingleChildScrollView(
        child: Material(
          elevation: 4.0,
          child: ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(8.0),
            itemCount: options.length,
            itemBuilder: (context, index) =>
                itemBuilder(context, index, onSelected),
          ),
        ),
      ),
      displayStringForOption: (option) => option.name ?? '',
      onSelected: onSelected,
    );
  }
}
