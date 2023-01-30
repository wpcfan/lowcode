part of 'page.dart';

class ProductRowPageBlock extends PageBlock {
  final int? width;
  final int? height;
  final List<ProductData> data;

  const ProductRowPageBlock({
    required int id,
    required int sort,
    required Platform platform,
    required String target,
    this.width,
    this.height,
    required this.data,
  }) : super(
          id: id,
          type: PageBlockType.productRow,
          sort: sort,
          platform: platform,
          target: target,
        );

  @override
  List<Object?> get props =>
      [id, type, sort, data, width, height, platform, target];

  factory ProductRowPageBlock.fromJson(Map<String, dynamic> json) {
    return ProductRowPageBlock(
      id: json['id'],
      sort: json['sort'],
      data: (json['data'] as List)
          .map((e) => ProductData.fromJson(e))
          .toList()
          .cast<ProductData>(),
      width: json['width'],
      height: json['height'],
      platform: json['platform'],
      target: json['target'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.value,
      'sort': sort,
      'data': data.map((e) => e.toJson()).toList(),
      'width': width,
      'height': height,
      'platform': platform,
      'target': target,
    };
  }
}
