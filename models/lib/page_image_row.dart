part of 'page_block.dart';

class ImageRowPageBlock extends PageBlock {
  final List<BlockData<ImageData>> data;

  const ImageRowPageBlock({
    required int id,
    required String title,
    required int sort,
    required BlockConfig config,
    required this.data,
  }) : super(
          id: id,
          title: title,
          type: PageBlockType.imageRow,
          sort: sort,
          config: config,
        );

  @override
  List<Object?> get props => [id, type, sort, data, title];

  factory ImageRowPageBlock.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] as List)
        .map((e) => BlockData.fromJson(e, ImageData.fromJson))
        .toList();
    data.sort((a, b) => a.sort.compareTo(b.sort));
    return ImageRowPageBlock(
      id: json['id'],
      title: json['title'],
      sort: json['sort'],
      config: BlockConfig.fromJson(json['config']),
      data: data,
    );
  }

  ImageRowPageBlock copyWith({
    int? id,
    String? title,
    int? sort,
    BlockConfig? config,
    List<BlockData<ImageData>>? data,
  }) {
    return ImageRowPageBlock(
      id: id ?? this.id,
      title: title ?? this.title,
      sort: sort ?? this.sort,
      config: config ?? this.config,
      data: data ?? this.data,
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

  @override
  String toString() {
    return 'ImageRowPageBlock(id: $id, title: $title, type: $type, sort: $sort, config: $config, data: $data)';
  }
}
