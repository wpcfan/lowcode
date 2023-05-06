import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'enumerations.dart';

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
