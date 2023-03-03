import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:models/product.dart';

import 'category.dart';
import 'enumerations.dart';

part 'page_block_config.dart';
part 'page_config.dart';
part 'page_image_data.dart';
part 'page_link.dart';

class PageBlock<T> extends Equatable {
  const PageBlock({
    this.id,
    required this.title,
    required this.type,
    required this.sort,
    required this.config,
    required this.data,
  });
  final int? id;
  final String title;
  final PageBlockType type;
  final int sort;
  final BlockConfig config;
  final List<BlockData<T>> data;

  static PageBlock<dynamic> mapPageBlock(Map<String, dynamic> json) {
    PageBlock result;
    if (json['type'] == PageBlockType.banner.value) {
      result = PageBlock.fromJson(json, ImageData.fromJson);
    } else if (json['type'] == PageBlockType.imageRow.value) {
      result = PageBlock.fromJson(json, ImageData.fromJson);
    } else if (json['type'] == PageBlockType.productRow.value) {
      result = PageBlock.fromJson(json, Product.fromJson);
    } else if (json['type'] == PageBlockType.waterfall.value) {
      result = PageBlock.fromJson(json, Category.fromJson);
    } else {
      result = PageBlock.fromJson(json, (e) => e);
    }
    return result;
  }

  factory PageBlock.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJson) {
    return PageBlock(
      id: json['id'],
      title: json['title'],
      type: PageBlockType.values.firstWhere((e) => e.value == json['type'],
          orElse: () => PageBlockType.unknown),
      sort: json['sort'],
      config: BlockConfig.fromJson(json['config']),
      data: (json['data'] as List)
          .map((e) => BlockData.fromJson(e, fromJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type.value,
      'sort': sort,
      'config': config.toJson(),
      'data': data.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [id, title, type, sort, config, data];

  PageBlock copyWith({
    int? id,
    String? title,
    PageBlockType? type,
    int? sort,
    BlockConfig? config,
    List<BlockData<T>>? data,
  }) {
    return PageBlock(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      sort: sort ?? this.sort,
      config: config ?? this.config,
      data: data ?? this.data,
    );
  }
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
