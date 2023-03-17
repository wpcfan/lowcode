part of 'page_block.dart';

class MyLink extends Equatable {
  const MyLink({
    required this.type,
    required this.value,
  });

  final LinkType type;
  final String value;

  @override
  List<Object?> get props => [type, value];

  factory MyLink.fromJson(Map<String, dynamic> json) {
    return MyLink(
      type: LinkType.values.firstWhere((e) => e.value == json['type']),
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.value,
      'value': value,
    };
  }

  MyLink copyWith({
    LinkType? type,
    String? value,
  }) {
    return MyLink(
      type: type ?? this.type,
      value: value ?? this.value,
    );
  }
}
