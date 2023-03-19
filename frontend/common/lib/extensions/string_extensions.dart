import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';

extension StringExtension on String {
  String get first => substring(0, 1);

  String get last => substring(length - 1, length);

  EasyRichText toEasyRichText({
    TextStyle? defaultStyle,
    List<EasyRichTextPattern>? patternList,
  }) =>
      EasyRichText(
        this,
        defaultStyle: defaultStyle,
        patternList: patternList,
      );

  /// 价格的富文本展示
  EasyRichText toPriceWithDecimalSize({
    double defaultFontSize = 14,
    double decimalFontSize = 12.0,
    String decimalSign = '.',
  }) {
    final defaultStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: defaultFontSize,
      color: Colors.red,
    );
    final parts = split(decimalSign);
    if (parts.length != 2) {
      return toEasyRichText(defaultStyle: defaultStyle, patternList: const []);
    }
    final first = parts.first;
    final last = parts.last;
    return toEasyRichText(
      defaultStyle: defaultStyle,
      patternList: [
        EasyRichTextPattern(
          targetString: first,
          matchWordBoundaries: false,
          style: TextStyle(
            fontSize: defaultFontSize,
          ),
        ),
        EasyRichTextPattern(
          targetString: last,
          matchWordBoundaries: false,
          style: TextStyle(
            fontSize: decimalFontSize,
          ),
        ),
      ],
    );
  }

  Text lineThru({
    double fontSize = 12.0,
    FontWeight fontWeight = FontWeight.w600,
    Color fontColor = Colors.grey,
  }) {
    return Text(this,
        style: TextStyle(
          fontWeight: fontWeight,
          fontSize: fontSize,
          color: fontColor,
          decoration: TextDecoration.lineThrough,
        ));
  }
}
