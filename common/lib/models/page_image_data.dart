part of 'page.dart';

class ImageData extends Equatable {
  const ImageData({
    required this.image,
    required this.sort,
    this.link,
    this.title,
    this.width,
    this.height,
  });

  final String image;
  final Link? link;
  final int sort;
  final String? title;
  final int? width;
  final int? height;

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      image: json['image'],
      link: json['link'] != null ? Link.fromJson(json['link']) : null,
      sort: json['sort'],
      title: json['title'],
      width: json['width'],
      height: json['height'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'link': link?.toJson(),
      'sort': sort,
      'title': title,
      'width': width,
      'height': height,
    };
  }

  @override
  List<Object?> get props => [image, link, sort, title, width, height];
}
