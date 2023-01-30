import 'package:common/common.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ProductTag extends Equatable {
  final String title;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final double fontSize;
  final double borderWidth;
  final double borderRadius;

  const ProductTag({
    this.title = '',
    this.backgroundColor = Colors.white,
    this.textColor = Colors.green,
    this.borderColor = Colors.green,
    this.fontSize = 10,
    this.borderWidth = 1,
    this.borderRadius = 2,
  });

  ProductTag copyWith({
    String? title,
    Color? backgroundColor,
    Color? textColor,
    Color? borderColor,
    double? fontSize,
    double? borderWidth,
    double? borderRadius,
  }) {
    return ProductTag(
      title: title ?? this.title,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      borderColor: borderColor ?? this.borderColor,
      fontSize: fontSize ?? this.fontSize,
      borderWidth: borderWidth ?? this.borderWidth,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'backgroundColor': '#${backgroundColor.value.toRadixString(16)}',
      'textColor': '#${textColor.value.toRadixString(16)}',
      'borderColor': '#${borderColor.value.toRadixString(16)}',
      'fontSize': fontSize,
      'borderWidth': borderWidth,
      'borderRadius': borderRadius,
    };
  }

  factory ProductTag.fromJson(Map<String, dynamic> json) {
    return ProductTag(
      title: json['title'] as String,
      backgroundColor: (json['backgroundColor'] as String).hexToColor(),
      textColor: (json['textColor'] as String).hexToColor(),
      borderColor: (json['borderColor'] as String).hexToColor(),
      fontSize: json['fontSize'] as double,
      borderWidth: json['borderWidth'] as double,
      borderRadius: json['borderRadius'] as double,
    );
  }

  @override
  List<Object?> get props => [
        title,
        backgroundColor,
        textColor,
        borderColor,
        fontSize,
        borderWidth,
        borderRadius,
      ];

  @override
  String toString() {
    return 'ProductTag(title: $title, backgroundColor: $backgroundColor, textColor: $textColor, borderColor: $borderColor, fontSize: $fontSize, borderWidth: $borderWidth, borderRadius: $borderRadius)';
  }
}
