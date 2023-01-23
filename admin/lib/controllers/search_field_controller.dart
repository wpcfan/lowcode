import 'dart:async';

import 'package:admin/repositories/github_repository.dart';
import 'package:flutter/material.dart';

class SearchFieldController extends ChangeNotifier {
  final List<String> _matched = [];
  final GithubRepository _githubRepository = GithubRepository();

  List<String> get matched => _matched;

  Future<void> query(String text) async {
    if (text.isEmpty) {
      _matched.clear();
    } else {
      final results = await _githubRepository.search(text);

      _matched.clear();
      _matched.addAll(results.items.map((item) => item.fullName));
    }
    notifyListeners();
  }
}
