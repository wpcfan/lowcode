class SliceWrapper<T> {
  final int page;
  final int size;
  final bool hasNext;
  final List<T> data;

  const SliceWrapper({
    required this.page,
    required this.size,
    required this.hasNext,
    required this.data,
  });

  factory SliceWrapper.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJson) {
    return SliceWrapper(
      page: json['page'],
      size: json['size'],
      hasNext: json['hasNext'],
      data: (json['data'] as List).map((e) => fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'size': size,
      'hasNext': hasNext,
      'data': data,
    };
  }

  SliceWrapper<T> copyWith({
    int? page,
    int? size,
    bool? hasNext,
    List<T>? data,
  }) {
    return SliceWrapper(
      page: page ?? this.page,
      size: size ?? this.size,
      hasNext: hasNext ?? this.hasNext,
      data: data ?? this.data,
    );
  }
}
