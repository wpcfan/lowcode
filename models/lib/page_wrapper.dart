class PageWrapper<T> {
  final List<T> items;
  final int page;
  final int size;
  final int totalPage;
  final int totalSize;

  PageWrapper({
    required this.items,
    required this.page,
    required this.size,
    required this.totalPage,
    required this.totalSize,
  });

  factory PageWrapper.fromJson(dynamic json, T Function(dynamic) fromJson) {
    final items = (json['items'] as List).map(fromJson).toList(growable: false);

    return PageWrapper(
      items: items,
      page: json['page'],
      size: json['size'],
      totalPage: json['totalPage'],
      totalSize: json['totalSize'],
    );
  }

  bool get isPopulated => items.isNotEmpty;

  bool get isEmpty => items.isEmpty;
}
