part of 'page_block.dart';

class PageConfig {
  const PageConfig({
    this.horizontalPadding,
    this.verticalPadding,
    this.baselineScreenWidth,
  });

  final double? horizontalPadding;
  final double? verticalPadding;
  final double? baselineScreenWidth;

  factory PageConfig.fromJson(Map<String, dynamic> json) {
    return PageConfig(
      horizontalPadding: json['horizontalPadding'],
      verticalPadding: json['verticalPadding'],
      baselineScreenWidth: json['baselineScreenWidth'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'horizontalPadding': horizontalPadding,
      'verticalPadding': verticalPadding,
      'baselineScreenWidth': baselineScreenWidth,
    };
  }

  @override
  String toString() {
    return 'PageConfig{horizontalPadding: $horizontalPadding, verticalPadding: $verticalPadding, baselineScreenWidth: $baselineScreenWidth}';
  }
}
