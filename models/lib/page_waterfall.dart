part of 'page_block.dart';

class WaterfallPageBlock extends PageBlock {
  final List<BlockData<Category>> data;

  const WaterfallPageBlock({
    int? id,
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
    final data = (json['data'] as List)
        .map((e) => BlockData.fromJson(e, Category.fromJson))
        .toList();
    data.sort((a, b) => a.sort.compareTo(b.sort));
    return WaterfallPageBlock(
      id: json['id'],
      title: json['title'],
      sort: json['sort'],
      config: BlockConfig.fromJson(json['config']),
      data: data,
    );
  }

  @override
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

  WaterfallPageBlock copyWith({
    int? id,
    String? title,
    int? sort,
    BlockConfig? config,
    List<BlockData<Category>>? data,
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
