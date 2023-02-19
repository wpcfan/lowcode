part of 'page_block.dart';

class BannerPageBlock extends PageBlock {
  final List<BlockData<ImageData>> data;

  const BannerPageBlock({
    required int id,
    required String title,
    required int sort,
    required BlockConfig config,
    required this.data,
  }) : super(
          id: id,
          title: title,
          type: PageBlockType.banner,
          sort: sort,
          config: config,
        );

  @override
  List<Object?> get props => [id, type, sort, data, title];

  factory BannerPageBlock.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] as List)
        .map((e) => BlockData.fromJson(e, ImageData.fromJson))
        .toList();
    data.sort((a, b) => a.sort.compareTo(b.sort));
    return BannerPageBlock(
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
      'type': describeEnum(type),
      'sort': sort,
      'config': config.toJson(),
      'data': data.map((e) => e.toJson()).toList(),
    };
  }

  BannerPageBlock copyWith({
    int? id,
    String? title,
    int? sort,
    BlockConfig? config,
    List<BlockData<ImageData>>? data,
  }) {
    return BannerPageBlock(
      id: id ?? this.id,
      title: title ?? this.title,
      sort: sort ?? this.sort,
      config: config ?? this.config,
      data: data ?? this.data,
    );
  }
}
