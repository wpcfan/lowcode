part of 'page_block.dart';

class Link extends Equatable {
  const Link({
    required this.type,
    required this.value,
  });

  final LinkType type;
  final String value;

  @override
  List<Object?> get props => [type, value];

  factory Link.fromJson(Map<String, dynamic> json) {
    debugPrint('Link.fromJson: $json');
    return Link(
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
}
