import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('swiftui', () {
    final widget = SwiftUi.widget(child: const Text('hello'));
    expect(widget.runtimeType, Text);
  });
}
