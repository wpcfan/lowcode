import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchFieldController extends ChangeNotifier {
  final List<String> _matched = [];

  List<String> get matched => _matched;

  Future query(String text) async {
    var client = http.Client();
    var response = await client.get(Uri.parse(
        'https://api.github.com/search/repositories?q=$text&sort=stars&order=desc'));
    if (response.statusCode == HttpStatus.ok) {
      var data = jsonDecode(response.body);
      _matched.clear();
      for (var item in data['items']) {
        _matched.add(item['full_name']);
      }
    }
    notifyListeners();
  }
}
