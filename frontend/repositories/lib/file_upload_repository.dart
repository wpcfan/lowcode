import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:networking/networking.dart';

import 'file_admin_repository.dart';

class FileUploadRepository {
  final String baseUrl;
  final Dio client;

  FileUploadRepository({
    Dio? client,
    this.baseUrl = '',
  }) : client = client ?? FileClient();

  Future<FileDto> uploadFile(UploadFile file) async {
    debugPrint('FileUploadRepository.upload($file)');

    final res = await client.post('/file', data: {
      'file': MultipartFile.fromBytes(
        file.file,
        filename: file.name,
      ),
    });
    if (res.data is! Map) {
      throw Exception(
          'FileUploadRepository.upload($file) - failed, res.data is not Map');
    }

    debugPrint('FileUploadRepository.upload($file) - success');
    final json = res.data as Map<String, dynamic>;
    final fileDto = FileDto.fromJson(json);
    return fileDto;
  }

  Future<List<FileDto>> uploadFiles(List<UploadFile> files) async {
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

    debugPrint('FileUploadRepository.upload($files) - success');
    final json = res.data as List<dynamic>;
    final fileDtos = json.map((e) => FileDto.fromJson(e)).toList();
    return fileDtos;
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
