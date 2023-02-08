import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class PageQuery {
  final String? title;
  final Platform? platform;
  final PageType? pageType;
  final PageStatus? status;
  final String? startDateFrom;
  final String? startDateTo;
  final String? endDateFrom;
  final String? endDateTo;

  PageQuery({
    this.title,
    this.platform,
    this.pageType,
    this.status,
    this.startDateFrom,
    this.startDateTo,
    this.endDateFrom,
    this.endDateTo,
  });
}

class PageRepository {
  final String baseUrl;
  final Map<String, PageSearchResult> cache;
  final http.Client client;

  PageRepository({
    http.Client? client,
    Map<String, PageSearchResult>? cache,
    this.baseUrl = 'http://localhost:8080/api/v1/admin/pages',
  })  : client = client ?? http.Client(),
        cache = cache ?? <String, PageSearchResult>{};

  Future<PageSearchResult> search(PageQuery query) async {
    final url = _buildUrl(query);
    final cachedResult = cache[url];

    if (cachedResult != null) {
      return cachedResult;
    }

    final response = await client.get(Uri.parse(url));
    final result = PageSearchResult.fromJson(jsonDecode(response.body));

    cache[url] = result;

    return result;
  }

  String _buildUrl(PageQuery query) {
    final params = <String, String>{};

    if (query.title != null) {
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

    final url = Uri.parse(baseUrl).replace(queryParameters: params);

    return url.toString();
  }
}

class PageSearchResult {
  final List<PageSearchResultItem> items;

  PageSearchResult(this.items);

  factory PageSearchResult.fromJson(dynamic json) {
    final items = (json as List)
        .map((item) => PageSearchResultItem.fromJson(item))
        .toList(growable: false);

    return PageSearchResult(items);
  }

  bool get isPopulated => items.isNotEmpty;

  bool get isEmpty => items.isEmpty;
}

enum Platform {
  app('App'),
  web('Web');

  final String value;

  const Platform(this.value);
}

enum PageType {
  home('home'),
  category('category'),
  about('about');

  final String value;

  const PageType(this.value);
}

enum PageStatus {
  draft('Draft'),
  published('Published'),
  archived('Archived');

  final String value;

  const PageStatus(this.value);
}

class PageConfig {
  final int horizontalPadding;
  final int verticalPadding;
  final int horiozontalSpacing;
  final int verticalSpacing;
  final int baselineScreenWidth;
  final int baselineScreenHeight;
  final int baselineFontSize;

  PageConfig({
    this.horizontalPadding = 16,
    this.verticalPadding = 16,
    this.horiozontalSpacing = 16,
    this.verticalSpacing = 16,
    this.baselineScreenWidth = 360,
    this.baselineScreenHeight = 640,
    this.baselineFontSize = 16,
  });
}

class PageSearchResultItem {
  final String title;
  final String url;
  final Platform platform;
  final PageType pageType;
  final PageConfig config;
  final PageStatus status;

  PageSearchResultItem({
    required this.title,
    required this.url,
    required this.platform,
    required this.pageType,
    required this.config,
    required this.status,
  });

  factory PageSearchResultItem.fromJson(dynamic json) {
    return PageSearchResultItem(
      title: json['title'] as String,
      url: json['url'] as String,
      platform: Platform.values.firstWhere(
        (e) => e.value == json['platform'],
        orElse: () => Platform.app,
      ),
      pageType: PageType.values.firstWhere(
        (e) => e.value == json['pageType'],
        orElse: () => PageType.home,
      ),
      config: PageConfig(
        horizontalPadding: json['config']['horizontalPadding'] as int,
        verticalPadding: json['config']['verticalPadding'] as int,
        horiozontalSpacing: json['config']['horiozontalSpacing'] as int,
        verticalSpacing: json['config']['verticalSpacing'] as int,
        baselineScreenWidth: json['config']['baselineScreenWidth'] as int,
        baselineScreenHeight: json['config']['baselineScreenHeight'] as int,
        baselineFontSize: json['config']['baselineFontSize'] as int,
      ),
      status: PageStatus.values.firstWhere(
        (e) => e.value == json['status'],
        orElse: () => PageStatus.draft,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'url': url,
      'platform': platform.value,
      'pageType': pageType.value,
      'config': {
        'horizontalPadding': config.horizontalPadding,
        'verticalPadding': config.verticalPadding,
        'horiozontalSpacing': config.horiozontalSpacing,
        'verticalSpacing': config.verticalSpacing,
        'baselineScreenWidth': config.baselineScreenWidth,
        'baselineScreenHeight': config.baselineScreenHeight,
        'baselineFontSize': config.baselineFontSize,
      },
      'status': status.value,
    };
  }

  @override
  String toString() {
    return 'PageSearchResultItem(title: $title, url: $url, platform: $platform, pageType: $pageType, config: $config, status: $status)';
  }
}
