import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class WidgetData extends Equatable {
  const WidgetData(
      {required this.icon,
      required this.label,
      this.sort,
      this.type = PageBlockType.banner});

  final IconData icon;
  final String label;
  final PageBlockType type;
  final int? sort;

  @override
  String toString() {
    return 'WidgetData{icon: $icon, label: $label, index: $sort}';
  }

  @override
  List<Object?> get props => [icon, label, sort];

  WidgetData copyWith({IconData? icon, String? label, int? sort}) {
    return WidgetData(
      icon: icon ?? this.icon,
      label: label ?? this.label,
      sort: sort ?? this.sort,
    );
  }
}
