part of 'page_block.dart';

class ProductRowPageBlock extends PageBlock {
  final List<ProductData> data;

  const ProductRowPageBlock({
    required int id,
    required String title,
    required int sort,
    required BlockConfig config,
    required this.data,
  }) : super(
          id: id,
          title: title,
          type: PageBlockType.productRow,
          sort: sort,
          config: config,
        );

  @override
  List<Object?> get props => [id, type, sort, data, config, title];

  factory ProductRowPageBlock.fromJson(Map<String, dynamic> json) {
    return ProductRowPageBlock(
      id: json['id'],
      title: json['title'],
      sort: json['sort'],
      data: (json['data'] as List)
          .map((e) => ProductData.fromJson(e))
          .toList()
          .cast<ProductData>(),
      config: BlockConfig.fromJson(json['config']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.value,
      'sort': sort,
      'data': data.map((e) => e.toJson()).toList(),
      'config': config.toJson(),
    };
  }
}
