import 'package:dio/dio.dart';
import 'package:networking/networking.dart';

class FileAdminRepository {
  final String baseUrl;
  final Dio client;

  FileAdminRepository({
    Dio? client,
    this.baseUrl = '/files',
  }) : client = client ?? AdminClient.getInstance();

  Future<List<FileDto>> getFiles() async {
    final res = await client.get('/files');
    if (res.data is! List) {
      throw Exception(
          'FileAdminRepository.getFiles() - failed, res.data is not List');
    }

    final json = res.data as List;
    final files = json.map((e) => FileDto.fromJson(e)).toList();
    return files;
  }

  Future<void> deleteFile(String key) async {
    await client.delete('/files/$key');
  }
}

class FileDto {
  final String key;
  final String url;

  FileDto({
    required this.key,
    required this.url,
  });

  factory FileDto.fromJson(Map<String, dynamic> json) {
    return FileDto(
      key: json['key'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'url': url,
    };
  }
}
