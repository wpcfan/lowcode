library page_repository;

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:models/models.dart';

export 'page_admin_repository.dart';

class PageLayoutCache<T> {
  final T value;
  final DateTime expires;

  PageLayoutCache({
    required this.value,
    required this.expires,
  });

  bool get isExpired => expires.isBefore(DateTime.now());
}

class PageRepository {
  final String baseUrl;
  final Map<String, PageLayoutCache> cache;
  final http.Client client;

  PageRepository({
    http.Client? client,
    Map<String, PageLayoutCache>? cache,
    this.baseUrl = 'http://localhost:8080/api/v1/app/pages',
  })  : client = client ?? http.Client(),
        cache = cache ?? <String, PageLayoutCache>{};

  Future<PageLayout> getByPageType(PageType pageType) async {
    final url = '$baseUrl/published/${pageType.value}';
    final cachedResult = cache[url];

    if (cachedResult != null && !cachedResult.isExpired) {
      return cachedResult.value;
    }

    final response = await client.get(Uri.parse(url));

    final result = PageLayout.fromJson(jsonDecode(response.body));

    cache[url] = PageLayoutCache(
      value: result,
      expires: DateTime.now().add(const Duration(minutes: 10)),
    );

    return result;
  }
}
