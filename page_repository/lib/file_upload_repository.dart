import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:networking/networking.dart';

class FileUploadRepository {
  final String baseUrl;
  final Dio client;

  FileUploadRepository({
    Dio? client,
    this.baseUrl = '/files',
  }) : client = client ?? FileClient.getInstance();

  Future<List<String>> uploadFiles(List<UploadFile> files) async {
    debugPrint('FileUploadRepository.upload($files)');

    FormData formData = FormData();
    for (var i = 0; i < files.length; i++) {
      formData.files.add(MapEntry(
          "files",
          MultipartFile.fromBytes(
            files[i].file,
            filename: files[i].name,
          )));
    }
    final res = await client.post('/files', data: formData);
    if (res.data is! List) {
      throw Exception(
          'FileUploadRepository.upload($files) - failed, res.data is not List');
    }

    final json = res.data as List;
    final urls = json.map((e) => e['url'] as String).toList();
    debugPrint('FileUploadRepository.upload($files) - success');
    return urls;
  }
}

class UploadFile {
  final String name;
  final Uint8List file;

  UploadFile({
    required this.name,
    required this.file,
  });

  factory UploadFile.fromJson(Map<String, dynamic> json) {
    return UploadFile(
      name: json['name'],
      file: json['file'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'file': file,
    };
  }
}
