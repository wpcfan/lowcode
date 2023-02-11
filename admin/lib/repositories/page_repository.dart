import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:models/models.dart';

class PageQuery extends Equatable {
  final String? title;
  final Platform? platform;
  final PageType? pageType;
  final PageStatus? status;
  final String? startDateFrom;
  final String? startDateTo;
  final String? endDateFrom;
  final String? endDateTo;
  final int page;

  const PageQuery({
    this.title,
    this.platform,
    this.pageType,
    this.status,
    this.startDateFrom,
    this.startDateTo,
    this.endDateFrom,
    this.endDateTo,
    this.page = 0,
  });

  PageQuery copyWith({
    String? title,
    Platform? platform,
    PageType? pageType,
    PageStatus? status,
    String? startDateFrom,
    String? startDateTo,
    String? endDateFrom,
    String? endDateTo,
    int? page,
  }) {
    return PageQuery(
      title: title ?? this.title,
      platform: platform ?? this.platform,
      pageType: pageType ?? this.pageType,
      status: status ?? this.status,
      startDateFrom: startDateFrom ?? this.startDateFrom,
      startDateTo: startDateTo ?? this.startDateTo,
      endDateFrom: endDateFrom ?? this.endDateFrom,
      endDateTo: endDateTo ?? this.endDateTo,
      page: page ?? this.page,
    );
  }

  String toJsonString() {
    return jsonEncode({
      'title': title,
      'platform': platform?.value,
      'pageType': pageType?.value,
      'status': status?.value,
      'startDateFrom': startDateFrom,
      'startDateTo': startDateTo,
      'endDateFrom': endDateFrom,
      'endDateTo': endDateTo,
      'page': page,
    });
  }

  @override
  List<Object?> get props => [
        title,
        platform,
        pageType,
        status,
        startDateFrom,
        startDateTo,
        endDateFrom,
        endDateTo,
        page,
      ];
}

class PageRepository {
  final String baseUrl;
  final Map<String, PageWrapper<PageSearchResultItem>> cache;
  final http.Client client;

  PageRepository({
    http.Client? client,
    Map<String, PageWrapper<PageSearchResultItem>>? cache,
    this.baseUrl = 'http://localhost:8080/api/v1/admin/pages',
  })  : client = client ?? http.Client(),
        cache = cache ?? <String, PageWrapper<PageSearchResultItem>>{};

  Future<PageWrapper<PageSearchResultItem>> search(PageQuery query) async {
    final url = _buildUrl(query);
    final cachedResult = cache[url];

    if (cachedResult != null) {
      return cachedResult;
    }

    final response = await client.get(Uri.parse(url));
    final result = PageWrapper.fromJson(
      jsonDecode(response.body),
      (json) => PageSearchResultItem.fromJson(json),
    );

    cache[url] = result;

    return result;
  }

  String _buildUrl(PageQuery query) {
    final params = <String, String>{};

    if (query.title != null && query.title!.isNotEmpty) {
      params['title'] = query.title!;
    }

    if (query.platform != null) {
      params['platform'] = query.platform!.value;
    }

    if (query.pageType != null) {
      params['pageType'] = query.pageType!.value;
    }

    if (query.status != null) {
      params['status'] = query.status!.value;
    }

    if (query.startDateFrom != null) {
      params['startDateFrom'] = query.startDateFrom!;
    }

    if (query.startDateTo != null) {
      params['startDateTo'] = query.startDateTo!;
    }

    if (query.endDateFrom != null) {
      params['endDateFrom'] = query.endDateFrom!;
    }

    if (query.endDateTo != null) {
      params['endDateTo'] = query.endDateTo!;
    }

    params['page'] = query.page.toString();

    final url = Uri.parse(baseUrl).replace(queryParameters: params);

    return url.toString();
  }
}

class PageWrapper<T> {
  final List<T> items;
  final int page;
  final int size;
  final int totalPage;
  final int totalSize;

  PageWrapper({
    required this.items,
    required this.page,
    required this.size,
    required this.totalPage,
    required this.totalSize,
  });

  factory PageWrapper.fromJson(dynamic json, T Function(dynamic) fromJson) {
    final items = (json['items'] as List).map(fromJson).toList(growable: false);

    return PageWrapper(
      items: items,
      page: json['page'],
      size: json['size'],
      totalPage: json['totalPage'],
      totalSize: json['totalSize'],
    );
  }

  bool get isPopulated => items.isNotEmpty;

  bool get isEmpty => items.isEmpty;
}

class PageConfig {
  final int horizontalPadding;
  final int verticalPadding;
  final int horizontalSpacing;
  final int verticalSpacing;
  final int baselineScreenWidth;
  final int baselineScreenHeight;
  final int baselineFontSize;

  PageConfig({
    this.horizontalPadding = 16,
    this.verticalPadding = 16,
    this.horizontalSpacing = 16,
    this.verticalSpacing = 16,
    this.baselineScreenWidth = 360,
    this.baselineScreenHeight = 640,
    this.baselineFontSize = 16,
  });

  factory PageConfig.fromJson(dynamic json) {
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
}

class PageSearchResultItem {
  final String title;
  final Platform platform;
  final PageType pageType;
  final PageConfig config;
  final PageStatus status;
  final DateTime? startTime;
  final DateTime? endTime;

  PageSearchResultItem({
    required this.title,
    required this.platform,
    required this.pageType,
    required this.config,
    required this.status,
    this.startTime,
    this.endTime,
  });

  factory PageSearchResultItem.fromJson(dynamic json) {
    return PageSearchResultItem(
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
    );
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
    };
  }

  bool get isDraft => status == PageStatus.draft;

  bool get isPublished => status == PageStatus.published;

  bool get isArchived => status == PageStatus.archived;

  @override
  String toString() {
    return 'PageSearchResultItem{title: $title, platform: $platform, pageType: $pageType, config: $config, status: $status, startTime: $startTime, endTime: $endTime}';
  }
}
