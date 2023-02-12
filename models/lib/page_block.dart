import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' hide Category;

import 'category.dart';
import 'enumerations.dart';
import 'product.dart';

part 'page_block_config.dart';
part 'page_category_data.dart';
part 'page_config.dart';
part 'page_image_data.dart';
part 'page_image_row.dart';
part 'page_link.dart';
part 'page_pinned_header.dart';
part 'page_product_data.dart';
part 'page_product_row.dart';
part 'page_slider.dart';
part 'page_waterfall.dart';

abstract class PageBlock extends Equatable {
  const PageBlock({
    required this.id,
    required this.title,
    required this.type,
    required this.sort,
    required this.config,
  });
  final int id;
  final String title;
  final PageBlockType type;
  final int sort;
  final BlockConfig config;

  factory PageBlock.fromJson(Map<String, dynamic> json) {
    final type = PageBlockType.values.firstWhere(
      (e) => describeEnum(e) == json['type'],
      orElse: () => PageBlockType.unknown,
    );
    switch (type) {
      case PageBlockType.imageRow:
        return ImageRowPageBlock.fromJson(json);
      case PageBlockType.productRow:
        return ProductRowPageBlock.fromJson(json);
      case PageBlockType.waterfall:
        return WaterfallPageBlock.fromJson(json);
      case PageBlockType.slider:
        return SliderPageBlock.fromJson(json);
      case PageBlockType.pinnedHeader:
        return PinnedHeaderPageBlock.fromJson(json);
      case PageBlockType.unknown:
      default:
        throw Exception('Unknown PageBlockType: $type');
    }
  }

  Map<String, dynamic> toJson();
}

class BlockData<T> {
  final int sort;
  final T data;

  BlockData({required this.sort, required this.data});

  factory BlockData.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJson) {
    return BlockData(
      sort: json['sort'],
      data: fromJson(json),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sort': sort,
      'data': data,
    };
  }
}
