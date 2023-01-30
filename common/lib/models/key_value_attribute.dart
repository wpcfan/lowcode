class KeyValueAttribute {
  final String key;
  final String value;

  const KeyValueAttribute({
    required this.key,
    required this.value,
  });

  KeyValueAttribute.fromJson(Map<String, dynamic> json)
      : key = json['key'],
        value = json['value'];

  Map<String, dynamic> toJson() => {
        'key': key,
        'value': value,
      };

  @override
  String toString() {
    return 'CartItemAttribute{key: $key, value: $value}';
  }

  KeyValueAttribute copyWith({
    String? key,
    String? value,
  }) {
    return KeyValueAttribute(
      key: key ?? this.key,
      value: value ?? this.value,
    );
  }
}
