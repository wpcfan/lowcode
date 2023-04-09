part of 'page_block.dart';

class BlockConfig {
  final double? horizontalPadding;
  final double? verticalPadding;
  final double? horizontalSpacing;
  final double? verticalSpacing;
  final double? blockWidth;
  final double? blockHeight;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;

  BlockConfig({
    this.horizontalPadding,
    this.verticalPadding,
    this.horizontalSpacing,
    this.verticalSpacing,
    this.blockWidth,
    this.blockHeight,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
  });

  factory BlockConfig.fromJson(Map<String, dynamic> json) {
    final hexBackgroundColor = json['backgroundColor'] as String?;
    final hexBorderColor = json['borderColor'] as String?;
    return BlockConfig(
      horizontalPadding: json['horizontalPadding'] as double?,
      verticalPadding: json['verticalPadding'] as double?,
      horizontalSpacing: json['horizontalSpacing'] as double?,
      verticalSpacing: json['verticalSpacing'] as double?,
      blockWidth: json['blockWidth'] as double?,
      blockHeight: json['blockHeight'] as double?,
      backgroundColor: hexBackgroundColor?.hexToColor(),
      borderColor: hexBorderColor?.hexToColor(),
      borderWidth: json['borderWidth'] as double?,
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
      'backgroundColor': backgroundColor != null
          ? '#${backgroundColor!.value.toRadixString(16)}'
          : null,
      'borderColor': borderColor != null
          ? '#${borderColor!.value.toRadixString(16)}'
          : null,
      'borderWidth': borderWidth,
    };
  }

  BlockConfig copyWith({
    double? horizontalPadding,
    double? verticalPadding,
    double? horizontalSpacing,
    double? verticalSpacing,
    double? blockWidth,
    double? blockHeight,
    Color? backgroundColor,
    Color? borderColor,
    double? borderWidth,
  }) {
    return BlockConfig(
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
      verticalPadding: verticalPadding ?? this.verticalPadding,
      horizontalSpacing: horizontalSpacing ?? this.horizontalSpacing,
      verticalSpacing: verticalSpacing ?? this.verticalSpacing,
      blockWidth: blockWidth ?? this.blockWidth,
      blockHeight: blockHeight ?? this.blockHeight,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
    );
  }

  BlockConfig withRatio(double ratio) {
    return BlockConfig(
      horizontalPadding: (horizontalPadding ?? 0) * ratio,
      verticalPadding: (verticalPadding ?? 0) * ratio,
      horizontalSpacing: (horizontalSpacing ?? 0) * ratio,
      verticalSpacing: (verticalSpacing ?? 0) * ratio,
      blockWidth: (blockWidth ?? 0) * ratio,
      blockHeight: (blockHeight ?? 0) * ratio,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      borderWidth: (borderWidth ?? 0) * ratio,
    );
  }

  @override
  String toString() {
    return 'BlockConfig(horizontalPadding: $horizontalPadding, verticalPadding: $verticalPadding, horizontalSpacing: $horizontalSpacing, verticalSpacing: $verticalSpacing, blockWidth: $blockWidth, blockHeight: $blockHeight, backgroundColor: $backgroundColor, borderColor: $borderColor, borderWidth: $borderWidth)';
  }
}
