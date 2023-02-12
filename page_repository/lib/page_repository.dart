library page_repository;

import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:models/models.dart';

class PageRepository {
  final String baseUrl;
  final Map<String, PageWrapper<PageLayout>> cache;
  final http.Client client;

  PageRepository({
    http.Client? client,
    Map<String, PageWrapper<PageLayout>>? cache,
    this.baseUrl = 'http://localhost:8080/api/v1/admin/pages',
  })  : client = client ?? http.Client(),
        cache = cache ?? <String, PageWrapper<PageLayout>>{};

  Future<PageWrapper<PageLayout>> search(PageQuery query) async {
    final url = _buildUrl(query);
    final cachedResult = cache[url];

    if (cachedResult != null) {
      return cachedResult;
    }

    final response = await client.get(Uri.parse(url));

    final result = PageWrapper.fromJson(
      jsonDecode(response.body),
      (json) => PageLayout.fromJson(json),
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
