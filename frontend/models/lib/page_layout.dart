import 'package:equatable/equatable.dart';

import 'category.dart';
import 'enumerations.dart';
import 'image_data.dart';
import 'page_block.dart';
import 'page_config.dart';
import 'product.dart';

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
    final blocks = (json['blocks'] as List<dynamic>).map((e) {
      if (e['type'] == PageBlockType.productRow.value) {
        return PageBlock.fromJson(e, Product.fromJson);
      } else if (e['type'] == PageBlockType.waterfall.value) {
        return PageBlock.fromJson(e, Category.fromJson);
      } else if (e['type'] == PageBlockType.imageRow.value) {
        return PageBlock.fromJson(e, ImageData.fromJson);
      } else if (e['type'] == PageBlockType.banner.value) {
        return PageBlock.fromJson(e, ImageData.fromJson);
      } else {
        return PageBlock.fromJson(e, (e) => e);
      }
    }).toList();
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

  factory PageLayout.empty() {
    return PageLayout(
      title: '',
      platform: Platform.app,
      pageType: PageType.home,
      config: PageConfig.empty(),
      status: PageStatus.draft,
    );
  }

  PageLayout copyWith({
    int? id,
    String? title,
    Platform? platform,
    PageType? pageType,
    PageConfig? config,
    PageStatus? status,
    DateTime? startTime,
    DateTime? endTime,
    List<PageBlock>? blocks,
  }) {
    return PageLayout(
      id: id ?? this.id,
      title: title ?? this.title,
      platform: platform ?? this.platform,
      pageType: pageType ?? this.pageType,
      config: config ?? this.config,
      status: status ?? this.status,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      blocks: blocks ?? this.blocks,
    );
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
