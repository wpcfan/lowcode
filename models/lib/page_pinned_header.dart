part of 'page_block.dart';

class PinnedHeaderPageBlock extends PageBlock {
  final List<BlockData<ImageData>> data;

  const PinnedHeaderPageBlock({
    required int id,
    required String title,
    required int sort,
    required BlockConfig config,
    required this.data,
  }) : super(
          id: id,
          title: title,
          type: PageBlockType.pinnedHeader,
          sort: sort,
          config: config,
        );

  @override
  List<Object?> get props => [id, type, sort, title, data, config];

  factory PinnedHeaderPageBlock.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] as List)
        .map((e) => BlockData.fromJson(e, ImageData.fromJson))
        .toList();
    data.sort((a, b) => a.sort.compareTo(b.sort));
    return PinnedHeaderPageBlock(
      id: json['id'],
      sort: json['sort'],
      title: json['title'],
      data: data,
      config: BlockConfig.fromJson(json['config']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.value,
      'sort': sort,
      'title': title,
      'data': data.map((e) => e.toJson()).toList(),
      'config': config.toJson(),
    };
  }
}
