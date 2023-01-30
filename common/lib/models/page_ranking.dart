part of 'page.dart';

class RankingData extends Equatable {
  final String id;
  final int sort;
  final String title;
  final String subtitle;
  final String image;
  final Link link;

  const RankingData({
    required this.id,
    required this.sort,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.link,
  });

  @override
  List<Object?> get props => [id, sort, title, subtitle, image, link];

  factory RankingData.fromJson(Map<String, dynamic> json) {
    return RankingData(
      id: json['id'],
      sort: json['sort'],
      title: json['title'],
      subtitle: json['subtitle'],
      image: json['image'],
      link: Link.fromJson(json['link']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sort': sort,
      'title': title,
      'subtitle': subtitle,
      'image': image,
      'link': link.toJson(),
    };
  }
}

class RankingListData extends Equatable {
  final String id;
  final String title;
  final String? headerImage;
  final int sort;
  final Link link;
  final List<RankingData> data;

  const RankingListData({
    required this.id,
    required this.title,
    required this.sort,
    required this.link,
    required this.data,
    this.headerImage,
  });

  @override
  List<Object?> get props => [id, title, sort, link, data, headerImage];

  factory RankingListData.fromJson(Map<String, dynamic> json) {
    return RankingListData(
      id: json['id'],
      title: json['title'],
      headerImage: json['header_image'],
      sort: json['sort'],
      link: Link.fromJson(json['link']),
      data: (json['data'] as List)
          .map((e) => RankingData.fromJson(e))
          .toList()
          .cast<RankingData>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'header_image': headerImage,
      'sort': sort,
      'link': link.toJson(),
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class RankingPageBlock extends PageBlock {
  final String title;
  final int? width;
  final List<RankingListData> data;

  const RankingPageBlock({
    required int id,
    required int sort,
    required Platform platform,
    required String target,
    required this.title,
    this.width,
    required this.data,
  }) : super(
          id: id,
          type: PageBlockType.ranking,
          sort: sort,
          platform: platform,
          target: target,
        );

  @override
  List<Object?> get props =>
      [id, type, sort, title, width, data, platform, target];

  factory RankingPageBlock.fromJson(Map<String, dynamic> json) {
    return RankingPageBlock(
      id: json['id'],
      sort: json['sort'],
      title: json['title'],
      width: json['width'],
      data: (json['data'] as List)
          .map((e) => RankingListData.fromJson(e))
          .toList()
          .cast<RankingListData>(),
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
      'title': title,
      'width': width,
      'data': data.map((e) => e.toJson()).toList(),
      'platform': platform,
      'target': target,
    };
  }
}
