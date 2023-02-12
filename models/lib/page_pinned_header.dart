part of 'page_block.dart';

class PinnedHeaderPageBlock extends PageBlock {
  final List<ImageData> data;

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
    final imageData = json['data'] as List;
    imageData.sort((a, b) => a['sort'] - b['sort']);
    return PinnedHeaderPageBlock(
      id: json['id'],
      sort: json['sort'],
      title: json['title'],
      data: imageData
          .map((e) => ImageData.fromJson(e))
          .toList()
          .cast<ImageData>(),
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
