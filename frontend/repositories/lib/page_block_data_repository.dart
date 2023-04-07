import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:models/models.dart';
import 'package:networking/networking.dart';

class PageBlockDataRepository {
  final String baseUrl;
  final Dio client;

  PageBlockDataRepository({
    Dio? client,
    this.baseUrl = '/pages',
  }) : client = client ?? AdminClient();

  Future<BlockData> addData(int pageId, int blockId, BlockData data) async {
    debugPrint('PageAdminRepository.addData($blockId, $data)');

    final url = '$baseUrl/$pageId/blocks/$blockId/data';
    final response = await client.post(url, data: data.toJson());

    final result = BlockData.mapBlockData(response.data);

    debugPrint('PageAdminRepository.addData($blockId, $data) - success');

    return result;
  }

  Future<BlockData> updateData(int pageId, int blockId, BlockData data) async {
    debugPrint('PageAdminRepository.updateData($blockId, $data)');

    final url = '$baseUrl/$pageId/blocks/$blockId/data/${data.id}';
    final response = await client.put(url, data: data.toJson());
    final json = response.data as Map<String, dynamic>;

    final result = BlockData.mapBlockData(json);

    debugPrint('PageAdminRepository.updateData($blockId, $data) - success');

    return result;
  }

  Future<void> deleteData(int pageId, int blockId, int dataId) async {
    debugPrint('PageAdminRepository.deleteData($blockId, $dataId)');

    final url = '$baseUrl/$pageId/blocks/$blockId/data/$dataId';
    await client.delete(url);

    debugPrint('PageAdminRepository.deleteData($blockId, $dataId) - success');
  }
}
