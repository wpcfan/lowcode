import 'package:equatable/equatable.dart';

class SpecAttribute extends Equatable {
  final String id;
  final String key;
  final String value;
  final int sort;
  final String productId;

  const SpecAttribute({
    required this.id,
    required this.key,
    required this.value,
    required this.sort,
    required this.productId,
  });

  SpecAttribute.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        key = json['key'],
        value = json['value'],
        sort = json['sort'],
        productId = json['productId'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'key': key,
        'value': value,
        'sort': sort,
        'productId': productId,
      };

  @override
  String toString() {
    return 'SpecAttribute{id: $id, key: $key, value: $value, sort: $sort, productId: $productId}';
  }

  SpecAttribute copyWith({
    String? id,
    String? key,
    String? value,
    int? sort,
    String? productId,
  }) {
    return SpecAttribute(
      id: id ?? this.id,
      key: key ?? this.key,
      value: value ?? this.value,
      sort: sort ?? this.sort,
      productId: productId ?? this.productId,
    );
  }

  @override
  List<Object?> get props => [id, key, value, sort, productId];
}
