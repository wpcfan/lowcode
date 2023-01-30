part of 'page.dart';

class WaterfallData extends Equatable {
  final String title;
  final List<ProductData> data;
  const WaterfallData(this.title, this.data);

  @override
  List<Object?> get props => [title, data];

  factory WaterfallData.fromJson(Map<String, dynamic> json) {
    return WaterfallData(
      json['title'],
      (json['data'] as List)
          .map((e) => ProductData.fromJson(e))
          .toList()
          .cast<ProductData>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}
