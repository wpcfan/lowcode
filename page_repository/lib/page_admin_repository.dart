import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:models/models.dart';
import 'package:networking/networking.dart';

class PageAdminRepository {
  final String baseUrl;
  final Dio client;

  PageAdminRepository({
    Dio? client,
    this.baseUrl = '/pages',
  }) : client = client ?? AdminClient.getInstance();

  /// 获取页面
  /// [id] 页面ID
  Future<PageLayout> get(int id) async {
    debugPrint('PageAdminRepository.get($id)');

    final url = '$baseUrl/$id';

    final response = await client.get(url);

    final result = PageLayout.fromJson(response.data);

    debugPrint('PageAdminRepository.get($id) - success');

    return result;
  }

  /// 创建页面
  /// [layout] 页面
  Future<PageLayout> create(PageLayout layout) async {
    debugPrint('PageAdminRepository.create($layout)');

    final response = await client.post(
      baseUrl,
      data: jsonEncode(layout.toJson()),
    );

    final result = PageLayout.fromJson(response.data);

    debugPrint('PageAdminRepository.create($layout) - success');

    return result;
  }

  /// 更新页面
  /// [layout] 页面
  /// [id] 页面ID
  Future<PageLayout> update(int id, PageLayout layout) async {
    debugPrint('PageAdminRepository.update($id, $layout)');

    final response = await client.put(
      '$baseUrl/$id',
      data: jsonEncode(layout.toJson()),
    );

    final result = PageLayout.fromJson(response.data);

    debugPrint('PageAdminRepository.update($id, $layout) - success');

    return result;
  }

  /// 删除页面
  /// [id] 页面ID
  Future<void> delete(int id) async {
    debugPrint('PageAdminRepository.delete($id)');

    await client.delete('$baseUrl/$id');

    debugPrint('PageAdminRepository.delete($id) - success');
  }

  /// 发布页面
  /// [id] 页面ID
  /// [startTime] 生效起始时间
  /// [endTime] 生效结束时间
  Future<PageLayout> publish(
      int id, DateTime? startTime, DateTime? endTime) async {
    debugPrint('PageAdminRepository.publish($id, $startTime, $endTime)');

    final response = await client.patch(
      '$baseUrl/$id/publish',
      data: jsonEncode({
        'startTime': startTime?.toIso8601String(),
        'endTime': endTime?.toIso8601String(),
      }),
    );

    final result = PageLayout.fromJson(response.data);

    debugPrint(
        'PageAdminRepository.publish($id, $startTime, $endTime) - success');

    return result;
  }

  /// 取消发布页面
  /// [id] 页面ID
  Future<PageLayout> draft(int id) async {
    debugPrint('PageAdminRepository.draft($id)');

    final response = await client.patch('$baseUrl/$id/draft');

    final result = PageLayout.fromJson(response.data);

    debugPrint('PageAdminRepository.draft($id) - success');

    return result;
  }

  /// 按条件查询页面
  /// [query] 查询条件
  Future<PageWrapper<PageLayout>> search(PageQuery query) async {
    debugPrint('PageAdminRepository.search($query)');

    final url = _buildUrl(query);
    debugPrint('PageAdminRepository.search($query) - url: $url');

    final response = await client.get(url, options: cacheOptions.toOptions());

    final result = PageWrapper.fromJson(
      response.data,
      (json) => PageLayout.fromJson(json),
    );

    debugPrint('PageAdminRepository.search($query) - success');

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

  PageQuery clear(String field) {
    switch (field) {
      case 'title':
        return PageQuery(
          title: null,
          platform: platform,
          pageType: pageType,
          status: status,
          startDateFrom: startDateFrom,
          startDateTo: startDateTo,
          endDateFrom: endDateFrom,
          endDateTo: endDateTo,
          page: page,
        );
      case 'platform':
        return PageQuery(
          title: title,
          platform: null,
          pageType: pageType,
          status: status,
          startDateFrom: startDateFrom,
          startDateTo: startDateTo,
          endDateFrom: endDateFrom,
          endDateTo: endDateTo,
          page: page,
        );
      case 'pageType':
        return PageQuery(
          title: title,
          platform: platform,
          pageType: null,
          status: status,
          startDateFrom: startDateFrom,
          startDateTo: startDateTo,
          endDateFrom: endDateFrom,
          endDateTo: endDateTo,
          page: page,
        );
      case 'status':
        return PageQuery(
          title: title,
          platform: platform,
          pageType: pageType,
          status: null,
          startDateFrom: startDateFrom,
          startDateTo: startDateTo,
          endDateFrom: endDateFrom,
          endDateTo: endDateTo,
          page: page,
        );
      case 'startDateFrom':
        return PageQuery(
          title: title,
          platform: platform,
          pageType: pageType,
          status: status,
          startDateFrom: null,
          startDateTo: startDateTo,
          endDateFrom: endDateFrom,
          endDateTo: endDateTo,
          page: page,
        );
      case 'startDateTo':
        return PageQuery(
          title: title,
          platform: platform,
          pageType: pageType,
          status: status,
          startDateFrom: startDateFrom,
          startDateTo: null,
          endDateFrom: endDateFrom,
          endDateTo: endDateTo,
          page: page,
        );
      case 'endDateFrom':
        return PageQuery(
          title: title,
          platform: platform,
          pageType: pageType,
          status: status,
          startDateFrom: startDateFrom,
          startDateTo: startDateTo,
          endDateFrom: null,
          endDateTo: endDateTo,
          page: page,
        );
      case 'endDateTo':
        return PageQuery(
          title: title,
          platform: platform,
          pageType: pageType,
          status: status,
          startDateFrom: startDateFrom,
          startDateTo: startDateTo,
          endDateFrom: endDateFrom,
          endDateTo: null,
          page: page,
        );
      default:
        return this;
    }
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
