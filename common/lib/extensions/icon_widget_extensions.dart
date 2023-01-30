import 'package:flutter/material.dart';

import 'widget_extensions.dart';

extension IconWidget<T extends Icon> on T {
  T copyWith({
    double? size,
    Color? color,
    String? semanticLabel,
    TextDirection? textDirection,
  }) =>
      Icon(
        icon,
        color: color ?? this.color,
        size: size ?? this.size,
        semanticLabel: semanticLabel ?? this.semanticLabel,
        textDirection: textDirection ?? this.textDirection,
      ) as T;

  T iconSize(double size) => this.copyWith(size: size);

  T iconColor(Color color) => this.copyWith(color: color);

  Widget rounded({
    required double size,
    Color? color,
    double? radius,
    double? borderWidth,
    Color? borderColor,
  }) =>
      constrained(width: size, height: size)
          .alignment(Alignment.center)
          .ripple()
          .decorated(
            color: color ?? Colors.transparent,
            borderRadius: BorderRadius.circular(size / 2),
            border: Border.all(
              color: borderColor ?? Colors.transparent,
              width: borderWidth ?? 0,
            ),
          )
          .clipRRect(all: size / 2);
}
