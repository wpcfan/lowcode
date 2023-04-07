import 'package:dio/dio.dart';
import 'package:networking/networking.dart';

class FileAdminRepository {
  final String baseUrl;
  final Dio client;

  FileAdminRepository({
    Dio? client,
    this.baseUrl = '/files',
  }) : client = client ?? AdminClient();

  Future<List<FileDto>> getFiles() async {
    final url = baseUrl;
    final res = await client.get(url);
    if (res.data is! List) {
      throw Exception(
          'FileAdminRepository.getFiles() - failed, res.data is not List');
    }

    final json = res.data as List;
    final files = json.map((e) => FileDto.fromJson(e)).toList();
    return files;
  }

  Future<void> deleteFile(String key) async {
    final url = '$baseUrl/$key';
    await client.delete(url);
  }

  Future<void> deleteFiles(List<String> keys) async {
    final url = baseUrl;
    await client.put(url, data: keys);
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
