part of 'page_block.dart';

class BlockConfig {
  final double? horizontalPadding;
  final double? verticalPadding;
  final double? horizontalSpacing;
  final double? verticalSpacing;
  final double? itemWidth;
  final double? itemHeight;
  final double? blockWidth;
  final double? blockHeight;

  BlockConfig({
    this.horizontalPadding,
    this.verticalPadding,
    this.horizontalSpacing,
    this.verticalSpacing,
    this.itemWidth,
    this.itemHeight,
    this.blockWidth,
    this.blockHeight,
  });

  factory BlockConfig.fromJson(Map<String, dynamic> json) {
    return BlockConfig(
      horizontalPadding: json['horizontalPadding'] as double?,
      verticalPadding: json['verticalPadding'] as double?,
      horizontalSpacing: json['horizontalSpacing'] as double?,
      verticalSpacing: json['verticalSpacing'] as double?,
      itemWidth: json['itemWidth'] as double?,
      itemHeight: json['itemHeight'] as double?,
      blockWidth: json['blockWidth'] as double?,
      blockHeight: json['blockHeight'] as double?,
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
      'blockWidth': blockWidth,
      'blockHeight': blockHeight,
    };
  }

  BlockConfig copyWith({
    double? horizontalPadding,
    double? verticalPadding,
    double? horizontalSpacing,
    double? verticalSpacing,
    double? itemWidth,
    double? itemHeight,
    double? blockWidth,
    double? blockHeight,
  }) {
    return BlockConfig(
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
      verticalPadding: verticalPadding ?? this.verticalPadding,
      horizontalSpacing: horizontalSpacing ?? this.horizontalSpacing,
      verticalSpacing: verticalSpacing ?? this.verticalSpacing,
      itemWidth: itemWidth ?? this.itemWidth,
      itemHeight: itemHeight ?? this.itemHeight,
      blockWidth: blockWidth ?? this.blockWidth,
      blockHeight: blockHeight ?? this.blockHeight,
    );
  }

  @override
  String toString() {
    return 'BlockConfig { horizontalPadding: $horizontalPadding, verticalPadding: $verticalPadding, horizontalSpacing: $horizontalSpacing, verticalSpacing: $verticalSpacing, itemWidth: $itemWidth, itemHeight: $itemHeight, blockWidth: $blockWidth, blockHeight: $blockHeight}';
  }
}
