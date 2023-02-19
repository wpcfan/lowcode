part of 'page_block.dart';

class BlockConfig {
  final double? horizontalPadding;
  final double? verticalPadding;
  final double? horizontalSpacing;
  final double? verticalSpacing;
  final double? blockWidth;
  final double? blockHeight;

  BlockConfig({
    this.horizontalPadding,
    this.verticalPadding,
    this.horizontalSpacing,
    this.verticalSpacing,
    this.blockWidth,
    this.blockHeight,
  });

  factory BlockConfig.fromJson(Map<String, dynamic> json) {
    return BlockConfig(
      horizontalPadding: json['horizontalPadding'] as double?,
      verticalPadding: json['verticalPadding'] as double?,
      horizontalSpacing: json['horizontalSpacing'] as double?,
      verticalSpacing: json['verticalSpacing'] as double?,
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
      'blockWidth': blockWidth,
      'blockHeight': blockHeight,
    };
  }

  BlockConfig copyWith({
    double? horizontalPadding,
    double? verticalPadding,
    double? horizontalSpacing,
    double? verticalSpacing,
    double? blockWidth,
    double? blockHeight,
  }) {
    return BlockConfig(
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
      verticalPadding: verticalPadding ?? this.verticalPadding,
      horizontalSpacing: horizontalSpacing ?? this.horizontalSpacing,
      verticalSpacing: verticalSpacing ?? this.verticalSpacing,
      blockWidth: blockWidth ?? this.blockWidth,
      blockHeight: blockHeight ?? this.blockHeight,
    );
  }

  @override
  String toString() {
    return 'BlockConfig { horizontalPadding: $horizontalPadding, verticalPadding: $verticalPadding, horizontalSpacing: $horizontalSpacing, verticalSpacing: $verticalSpacing, blockWidth: $blockWidth, blockHeight: $blockHeight}';
  }
}
