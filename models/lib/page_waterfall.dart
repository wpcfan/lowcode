part of 'page_block.dart';

class WaterfallPageBlock extends PageBlock {
  final List<CategoryData> data;

  const WaterfallPageBlock({
    required int id,
    required String title,
    required int sort,
    required BlockConfig config,
    required this.data,
  }) : super(
          id: id,
          title: title,
          type: PageBlockType.waterfall,
          sort: sort,
          config: config,
        );

  @override
  List<Object?> get props => [id, type, sort, data, title];

  factory WaterfallPageBlock.fromJson(Map<String, dynamic> json) {
    return WaterfallPageBlock(
      id: json['id'],
      title: json['title'],
      sort: json['sort'],
      config: BlockConfig.fromJson(json['config']),
      data: (json['data'] as List)
          .map((e) => CategoryData.fromJson(e))
          .toList()
          .cast<CategoryData>(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': describeEnum(type),
      'sort': sort,
      'config': config.toJson(),
      'data': data.map((e) => e.toJson()).toList(),
    };
  }

  WaterfallPageBlock copyWith({
    int? id,
    String? title,
    int? sort,
    BlockConfig? config,
    List<CategoryData>? data,
  }) {
    return WaterfallPageBlock(
      id: id ?? this.id,
      title: title ?? this.title,
      sort: sort ?? this.sort,
      config: config ?? this.config,
      data: data ?? this.data,
    );
  }

  @override
  String toString() {
    return 'WaterfallPageBlock(id: $id, title: $title, sort: $sort, config: $config, data: $data)';
  }
}
