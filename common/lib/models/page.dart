import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../enumerations/all.dart';
import 'product.dart';

part 'page_image_data.dart';
part 'page_image_row.dart';
part 'page_pinned_header.dart';
part 'page_product_data.dart';
part 'page_product_row.dart';
part 'page_ranking.dart';
part 'page_slider.dart';
part 'page_waterfall.dart';
part 'page_waterfall_data.dart';

enum PageBlockType {
  pinnedHeader('pinned_header'),
  slider('slider'),
  imageRow('image_row'),
  productRow('product_row'),
  waterfall('waterfall'),
  ranking('ranking'),
  ;

  final String value;
  const PageBlockType(this.value);
}

enum LinkType {
  url('url'),
  deepLink('deep_link'),
  ;

  final String value;
  const LinkType(this.value);
}

class Link extends Equatable {
  const Link({
    required this.type,
    required this.value,
  });

  final LinkType type;
  final String value;

  @override
  List<Object?> get props => [type, value];

  factory Link.fromJson(Map<String, dynamic> json) {
    debugPrint('Link.fromJson: $json');
    return Link(
      type: LinkType.values.firstWhere((e) => e.value == json['type']),
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.value,
      'value': value,
    };
  }
}

abstract class PageBlock extends Equatable {
  const PageBlock({
    required this.id,
    required this.type,
    required this.sort,
    required this.platform,
    required this.target,
  });
  final int id;
  final PageBlockType type;
  final int sort;
  final Platform platform;
  final String target;

  factory PageBlock.fromJson(Map<String, dynamic> json) {
    final type =
        PageBlockType.values.firstWhere((e) => e.value == json['type']);
    switch (type) {
      case PageBlockType.pinnedHeader:
        return PinnedHeaderPageBlock.fromJson(json);
      case PageBlockType.slider:
        return SliderPageBlock.fromJson(json);
      case PageBlockType.imageRow:
        return ImageRowPageBlock.fromJson(json);
      case PageBlockType.productRow:
        return ProductRowPageBlock.fromJson(json);
      case PageBlockType.waterfall:
        return WaterfallPageBlock.fromJson(json);
      case PageBlockType.ranking:
        return RankingPageBlock.fromJson(json);
    }
  }

  Map<String, dynamic> toJson();
}
