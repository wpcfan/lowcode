class Problem {
  final String? title;
  final String? detail;
  final String? instance;
  final int? status;
  final String? type;
  final int? code;
  final String? ua;
  final String? locale;

  Problem({
    this.title,
    this.detail,
    this.instance,
    this.status,
    this.type,
    this.code,
    this.ua,
    this.locale,
  });

  factory Problem.fromJson(Map<String, dynamic> json) {
    return Problem(
      title: json['title'],
      detail: json['detail'],
      instance: json['instance'],
      status: json['status'],
      type: json['type'],
      code: json['code'],
      ua: json['ua'],
      locale: json['locale'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'detail': detail,
      'instance': instance,
      'status': status,
      'type': type,
      'code': code,
      'ua': ua,
      'locale': locale,
    };
  }

  @override
  String toString() {
    return 'Problem{title: $title, detail: $detail, instance: $instance, status: $status, type: $type, code: $code, ua: $ua, locale: $locale}';
  }

  Problem copyWith({
    String? title,
    String? detail,
    String? instance,
    int? status,
    String? type,
    int? code,
    String? ua,
    String? locale,
  }) {
    return Problem(
      title: title ?? this.title,
      detail: detail ?? this.detail,
      instance: instance ?? this.instance,
      status: status ?? this.status,
      type: type ?? this.type,
      code: code ?? this.code,
      ua: ua ?? this.ua,
      locale: locale ?? this.locale,
    );
  }
}
