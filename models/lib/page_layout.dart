import 'package:equatable/equatable.dart';
import 'package:models/enumerations.dart';

import 'page_block.dart';

class PageLayout extends Equatable {
  final int? id;
  final String title;
  final Platform platform;
  final PageType pageType;
  final PageConfig config;
  final PageStatus status;
  final DateTime? startTime;
  final DateTime? endTime;
  final List<PageBlock> blocks;

  const PageLayout({
    this.id,
    required this.title,
    required this.platform,
    required this.pageType,
    required this.config,
    required this.status,
    this.startTime,
    this.endTime,
    this.blocks = const [],
  });

  factory PageLayout.fromJson(
    dynamic json,
  ) {
    final blocks = (json['blocks'] as List<dynamic>)
        .map((e) => PageBlock.fromJson(e))
        .toList();
    blocks.sort((a, b) => a.sort.compareTo(b.sort));
    return PageLayout(
      id: json['id'] as int?,
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
      blocks: blocks,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
    return 'PageLayout{id: $id, title: $title, platform: $platform, pageType: $pageType, config: $config, status: $status, startTime: $startTime, endTime: $endTime}';
  }

  @override
  List<Object?> get props => [
        id,
        title,
        platform,
        pageType,
        config,
        status,
        startTime,
        endTime,
        blocks,
      ];
}
