import 'package:flutter/material.dart';

class SwiftUi {
  static Widget builder({
    required Widget Function(BuildContext context, Widget child) builder,
    required Widget child,
  }) =>
      Builder(
        builder: (context) => builder(
          context,
          child,
        ),
      );

  static Widget widget({Widget? child}) =>
      child ??
      LimitedBox(
        maxWidth: 0.0,
        maxHeight: 0.0,
        child: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
        ),
      );
}
