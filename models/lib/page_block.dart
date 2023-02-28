import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' hide Category;

import 'category.dart';
import 'enumerations.dart';
import 'product.dart';

part 'page_banner.dart';
part 'page_block_config.dart';
part 'page_config.dart';
part 'page_image_data.dart';
part 'page_image_row.dart';
part 'page_link.dart';
part 'page_product_row.dart';
part 'page_waterfall.dart';

abstract class PageBlock extends Equatable {
  const PageBlock({
    this.id,
    required this.title,
    required this.type,
    required this.sort,
    required this.config,
  });
  final int? id;
  final String title;
  final PageBlockType type;
  final int sort;
  final BlockConfig config;

  factory PageBlock.fromJson(Map<String, dynamic> json) {
    final type = PageBlockType.values.firstWhere(
      (e) => e.value == json['type'],
      orElse: () => PageBlockType.unknown,
    );
    switch (type) {
      case PageBlockType.imageRow:
        return ImageRowPageBlock.fromJson(json);
      case PageBlockType.productRow:
        return ProductRowPageBlock.fromJson(json);
      case PageBlockType.waterfall:
        return WaterfallPageBlock.fromJson(json);
      case PageBlockType.banner:
        return BannerPageBlock.fromJson(json);
      case PageBlockType.unknown:
      default:
        throw Exception('Unknown PageBlockType: $type');
    }
  }

  Map<String, dynamic> toJson();
}

class BlockData<T> {
  final int id;
  final int sort;
  final T content;

  BlockData({required this.id, required this.sort, required this.content});

  factory BlockData.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJson) {
    return BlockData(
      id: json['id'],
      sort: json['sort'],
      content: fromJson(json['content']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sort': sort,
      'data': content,
    };
  }
}
