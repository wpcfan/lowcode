part of 'page_block.dart';

class BlockConfig {
  final int? horizontalPadding;
  final int? verticalPadding;
  final int? horizontalSpacing;
  final int? verticalSpacing;
  final double? itemWidth;
  final double? itemHeight;

  BlockConfig({
    this.horizontalPadding,
    this.verticalPadding,
    this.horizontalSpacing,
    this.verticalSpacing,
    this.itemWidth,
    this.itemHeight,
  });

  factory BlockConfig.fromJson(Map<String, dynamic> json) {
    return BlockConfig(
      horizontalPadding: json['horizontalPadding'] as int?,
      verticalPadding: json['verticalPadding'] as int?,
      horizontalSpacing: json['horizontalSpacing'] as int?,
      verticalSpacing: json['verticalSpacing'] as int?,
      itemWidth: json['itemWidth'] as double?,
      itemHeight: json['itemHeight'] as double?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'horizontalPadding': horizontalPadding,
      'verticalPadding': verticalPadding,
      'horizontalSpacing': horizontalSpacing,
      'verticalSpacing': verticalSpacing,
      'itemWidth': itemWidth,
      'itemHeight': itemHeight,
    };
  }

  BlockConfig copyWith({
    int? horizontalPadding,
    int? verticalPadding,
    int? horizontalSpacing,
    int? verticalSpacing,
    double? itemWidth,
    double? itemHeight,
  }) {
    return BlockConfig(
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
      verticalPadding: verticalPadding ?? this.verticalPadding,
      horizontalSpacing: horizontalSpacing ?? this.horizontalSpacing,
      verticalSpacing: verticalSpacing ?? this.verticalSpacing,
      itemWidth: itemWidth ?? this.itemWidth,
      itemHeight: itemHeight ?? this.itemHeight,
    );
  }

  @override
  String toString() {
    return 'BlockConfig(horizontalPadding: $horizontalPadding, verticalPadding: $verticalPadding, horizontalSpacing: $horizontalSpacing, verticalSpacing: $verticalSpacing, itemWidth: $itemWidth, itemHeight: $itemHeight)';
  }
}
