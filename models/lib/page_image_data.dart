part of 'page_block.dart';

class ImageData extends Equatable {
  const ImageData({
    required this.image,
    this.link,
    this.title,
  });

  final String image;
  final Link? link;
  final String? title;

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      image: json['image'],
      link: json['link'] != null ? Link.fromJson(json['link']) : null,
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'link': link?.toJson(),
      'title': title,
    };
  }

  @override
  List<Object?> get props => [image, link, title];
}