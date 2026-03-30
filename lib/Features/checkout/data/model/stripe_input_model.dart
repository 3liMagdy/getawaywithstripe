class StripeInputModel {
  final String currency;
  final int amount; // Amount must be an integer (in cents, e.g., 5097 for $50.97)

  StripeInputModel({required this.currency, required this.amount});

  Map<String, dynamic> toJson() => {
    'currency': currency,
    'amount': amount,
  };

  factory StripeInputModel.fromJson(Map<String, dynamic> json) {
    return StripeInputModel(
      currency: json['currency'],
      amount: json['amount'],
    );
  }
}