part of 'page_block.dart';

enum WaterfallDataType {
  category('category'),
  product('product'),
  ;

  final String value;

  const WaterfallDataType(this.value);
}

class WaterfallPageBlock extends PageBlock {
  final int? width;
  final int? height;
  final List<WaterfallData> data;

  const WaterfallPageBlock({
    required int id,
    required int sort,
    required Platform platform,
    required String target,
    this.width,
    this.height,
    required this.data,
  }) : super(
          id: id,
          type: PageBlockType.waterfall,
          sort: sort,
          platform: platform,
          target: target,
        );

  @override
  List<Object?> get props =>
      [id, type, sort, data, width, height, platform, target];

  factory WaterfallPageBlock.fromJson(Map<String, dynamic> json) {
    return WaterfallPageBlock(
      id: json['id'],
      sort: json['sort'],
      data: (json['data'] as List)
          .map((e) => WaterfallData.fromJson(e))
          .toList()
          .cast<WaterfallData>(),
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
