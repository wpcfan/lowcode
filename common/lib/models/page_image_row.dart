part of 'page.dart';

class ImageRowPageBlock extends PageBlock {
  final String? title;
  final int? width;
  final int? height;
  final List<ImageData> data;

  const ImageRowPageBlock({
    required int id,
    required int sort,
    required Platform platform,
    required String target,
    this.title,
    this.width,
    this.height,
    required this.data,
  }) : super(
          id: id,
          type: PageBlockType.imageRow,
          sort: sort,
          platform: platform,
          target: target,
        );

  @override
  List<Object?> get props =>
      [id, type, sort, data, title, width, height, platform, target];

  factory ImageRowPageBlock.fromJson(Map<String, dynamic> json) {
    final imageData = json['data'] as List;
    imageData.sort((a, b) => a['sort'] - b['sort']);
    return ImageRowPageBlock(
      id: json['id'],
      sort: json['sort'],
      data: imageData
          .map((e) => ImageData.fromJson(e))
          .toList()
          .cast<ImageData>(),
      title: json['title'],
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
      'title': title,
      'width': width,
      'height': height,
      'platform': platform,
      'target': target,
    };
  }
}
