part of 'page_block.dart';

class ImageData extends Equatable {
  const ImageData({
    required this.image,
    this.link,
    this.title,
  });

  final String image;
  final MyLink? link;
  final String? title;

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      image: json['image'],
      link: json['link'] != null ? MyLink.fromJson(json['link']) : null,
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

  ImageData copyWith({
    String? image,
    MyLink? link,
    String? title,
  }) {
    return ImageData(
      image: image ?? this.image,
      link: link ?? this.link,
      title: title ?? this.title,
    );
  }

  @override
  List<Object?> get props => [image, link, title];

  @override
  String toString() {
    return 'ImageData(image: $image, link: $link, title: $title)';
  }
}
