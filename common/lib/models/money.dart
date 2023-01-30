import 'package:equatable/equatable.dart';

import 'currency.dart';

class Money extends Equatable {
  final int? amount;
  final Currency? currency;
  final String? formatted;

  const Money(this.amount, this.currency, this.formatted);

  Money.fromJson(Map<String, dynamic> json)
      : amount = json['amount'] as int?,
        currency = json['currency'] != null
            ? Currency.fromJson(json['currency'] as Map<String, dynamic>)
            : null,
        formatted = json['formatted'] as String?;

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'currency': currency?.toJson(),
        'formatted': formatted,
      };

  @override
  String toString() {
    return 'Money{amount: $amount, currency: $currency, formatted: $formatted}';
  }

  Money copyWith({
    int? amount,
    Currency? currency,
    String? formatted,
  }) {
    return Money(
      amount ?? this.amount,
      currency ?? this.currency,
      formatted ?? this.formatted,
    );
  }

  @override
  List<Object?> get props => [amount, currency, formatted];
}
