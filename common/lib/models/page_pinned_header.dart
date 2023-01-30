part of 'page.dart';

class PinnedHeaderPageBlock extends PageBlock {
  final int maxHeight;
  final int minHeight;
  final String title;
  final List<ImageData> data;

  const PinnedHeaderPageBlock({
    required int id,
    required int sort,
    required Platform platform,
    required String target,
    required this.maxHeight,
    required this.minHeight,
    required this.title,
    required this.data,
  }) : super(
          id: id,
          type: PageBlockType.pinnedHeader,
          sort: sort,
          platform: platform,
          target: target,
        );

  @override
  List<Object?> get props =>
      [id, type, sort, maxHeight, minHeight, title, data, platform, target];

  factory PinnedHeaderPageBlock.fromJson(Map<String, dynamic> json) {
    final imageData = json['data'] as List;
    imageData.sort((a, b) => a['sort'] - b['sort']);
    return PinnedHeaderPageBlock(
      id: json['id'],
      sort: json['sort'],
      maxHeight: json['maxHeight'],
      minHeight: json['minHeight'],
      title: json['title'],
      data: imageData
          .map((e) => ImageData.fromJson(e))
          .toList()
          .cast<ImageData>(),
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
      'maxHeight': maxHeight,
      'minHeight': minHeight,
      'title': title,
      'data': data.map((e) => e.toJson()).toList(),
      'platform': platform,
      'target': target,
    };
  }
}
