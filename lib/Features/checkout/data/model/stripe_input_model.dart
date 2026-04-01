class StripeInputModel {
  final String currency;
  final int amount;
  final String customer;

  StripeInputModel({
    required this.currency,
    required this.amount,
    required this.customer,
  });

  Map<String, dynamic> toJson() => {
    'currency': currency,
    'amount': amount,
    'customer': customer,
  };

  factory StripeInputModel.fromJson(Map<String, dynamic> json) {
    return StripeInputModel(
      currency: json['currency'],
      amount: json['amount'],
      customer: json['customer'],
    );
  }
}
