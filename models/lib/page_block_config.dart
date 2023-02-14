part of 'page_block.dart';

class BlockConfig {
  final double? horizontalPadding;
  final double? verticalPadding;
  final double? horizontalSpacing;
  final double? verticalSpacing;
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
      horizontalPadding: json['horizontalPadding'] as double?,
      verticalPadding: json['verticalPadding'] as double?,
      horizontalSpacing: json['horizontalSpacing'] as double?,
      verticalSpacing: json['verticalSpacing'] as double?,
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
    double? horizontalPadding,
    double? verticalPadding,
    double? horizontalSpacing,
    double? verticalSpacing,
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
