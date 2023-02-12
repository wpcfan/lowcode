import 'package:models/enumerations.dart';

import 'page_block.dart';

class PageLayout {
  final String title;
  final Platform platform;
  final PageType pageType;
  final PageConfig config;
  final PageStatus status;
  final DateTime? startTime;
  final DateTime? endTime;
  final List<PageBlock> blocks;

  PageLayout({
    required this.title,
    required this.platform,
    required this.pageType,
    required this.config,
    required this.status,
    this.startTime,
    this.endTime,
    this.blocks = const [],
  });

  factory PageLayout.fromJson(dynamic json) {
    return PageLayout(
        title: json['title'] as String,
        platform: Platform.values.firstWhere(
          (e) => e.value == json['platform'],
          orElse: () => Platform.app,
        ),
        pageType: PageType.values.firstWhere(
          (e) => e.value == json['pageType'],
          orElse: () => PageType.home,
        ),
        config: PageConfig.fromJson(json['config']),
        status: PageStatus.values.firstWhere(
          (e) => e.value == json['status'],
          orElse: () => PageStatus.draft,
        ),
        startTime: json['startTime'] == null
            ? null
            : DateTime.parse(json['startTime'] as String),
        endTime: json['endTime'] == null
            ? null
            : DateTime.parse(json['endTime'] as String),
        blocks: (json['blocks'] as List<PageBlock>? ?? []));
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'platform': platform.value,
      'pageType': pageType.value,
      'config': config.toJson(),
      'status': status.value,
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'blocks': blocks.map((e) => e.toJson()).toList(),
    };
  }

  bool get isDraft => status == PageStatus.draft;

  bool get isPublished => status == PageStatus.published;

  bool get isArchived => status == PageStatus.archived;

  @override
  String toString() {
    return 'PageLayout{title: $title, platform: $platform, pageType: $pageType, config: $config, status: $status, startTime: $startTime, endTime: $endTime}';
  }
}
