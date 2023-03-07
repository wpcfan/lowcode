import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:models/models.dart';
import 'package:networking/networking.dart';

class PageBlockRepository {
  final String baseUrl;
  final Dio client;

  PageBlockRepository({
    Dio? client,
    this.baseUrl = '/pages',
  }) : client = client ?? AdminClient.getInstance();

  Future<PageLayout> createBlock(int pageId, PageBlock block) async {
    debugPrint('PageAdminRepository.createBlock($pageId, $block)');

    final url = '$baseUrl/$pageId/blocks';
    final response = await client.post(url, data: block.toJson());

    final result = PageLayout.fromJson(response.data);

    debugPrint('PageAdminRepository.createBlock($pageId, $block) - success');

    return result;
  }

  Future<PageLayout> insertBlock(int pageId, PageBlock block) async {
    debugPrint('PageAdminRepository.createBlock($pageId, $block)');

    final url = '$baseUrl/$pageId/blocks/insert';
    final response = await client.post(url, data: block.toJson());

    final result = PageLayout.fromJson(response.data);

    debugPrint('PageAdminRepository.createBlock($pageId, $block) - success');

    return result;
  }

  Future<PageLayout> moveBlock(int pageId, int blockId, int sort) async {
    debugPrint('PageAdminRepository.moveBlock($pageId, $blockId, $sort)');

    final url = '$baseUrl/$pageId/blocks/$blockId/move/$sort';
    final response = await client.patch(url);

    final result = PageLayout.fromJson(response.data);

    debugPrint(
        'PageAdminRepository.moveBlock($pageId, $blockId, $sort) - success');

    return result;
  }

  Future<PageBlock> updateBlock(
      int pageId, int blockId, PageBlock block) async {
    debugPrint('PageAdminRepository.updateBlock($pageId, $blockId, $block)');

    final url = '$baseUrl/$pageId/blocks/$blockId';
    final response = await client.put(url, data: block.toJson());

    final result = PageBlock.mapPageBlock(response.data);

    debugPrint(
        'PageAdminRepository.updateBlock($pageId, $blockId, $block) - success');

    return result;
  }

  Future<void> deleteBlock(int pageId, int blockId) async {
    debugPrint('PageAdminRepository.deleteBlock($pageId, $blockId)');

    final url = '$baseUrl/$pageId/blocks/$blockId';
    await client.delete(url);

    debugPrint('PageAdminRepository.deleteBlock($pageId, $blockId) - success');
  }
}
