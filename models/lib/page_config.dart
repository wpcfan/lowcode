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

  PageConfig copyWith({
    double? horizontalPadding,
    double? verticalPadding,
    double? baselineScreenWidth,
  }) {
    return PageConfig(
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
      verticalPadding: verticalPadding ?? this.verticalPadding,
      baselineScreenWidth: baselineScreenWidth ?? this.baselineScreenWidth,
    );
  }

  factory PageConfig.empty() {
    return const PageConfig(
      horizontalPadding: 0,
      verticalPadding: 0,
      baselineScreenWidth: 0,
    );
  }

  @override
  String toString() {
    return 'PageConfig{horizontalPadding: $horizontalPadding, verticalPadding: $verticalPadding, baselineScreenWidth: $baselineScreenWidth}';
  }
}
