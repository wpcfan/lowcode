part of 'page_block.dart';

class PageConfig {
  const PageConfig({
    this.horizontalPadding,
    this.verticalPadding,
    this.horizontalSpacing,
    this.verticalSpacing,
    this.baselineScreenWidth,
    this.baselineScreenHeight,
    this.baselineFontSize,
  });

  final int? horizontalPadding;
  final int? verticalPadding;
  final int? horizontalSpacing;
  final int? verticalSpacing;
  final int? baselineScreenWidth;
  final int? baselineScreenHeight;
  final int? baselineFontSize;

  factory PageConfig.fromJson(Map<String, dynamic> json) {
    return PageConfig(
      horizontalPadding: json['horizontalPadding'],
      verticalPadding: json['verticalPadding'],
      horizontalSpacing: json['horizontalSpacing'],
      verticalSpacing: json['verticalSpacing'],
      baselineScreenWidth: json['baselineScreenWidth'],
      baselineScreenHeight: json['baselineScreenHeight'],
      baselineFontSize: json['baselineFontSize'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'horizontalPadding': horizontalPadding,
      'verticalPadding': verticalPadding,
      'horizontalSpacing': horizontalSpacing,
      'verticalSpacing': verticalSpacing,
      'baselineScreenWidth': baselineScreenWidth,
      'baselineScreenHeight': baselineScreenHeight,
      'baselineFontSize': baselineFontSize,
    };
  }

  @override
  String toString() {
    return 'PageConfig{horizontalPadding: $horizontalPadding, verticalPadding: $verticalPadding, horizontalSpacing: $horizontalSpacing, verticalSpacing: $verticalSpacing, baselineScreenWidth: $baselineScreenWidth, baselineScreenHeight: $baselineScreenHeight, baselineFontSize: $baselineFontSize}';
  }
}
