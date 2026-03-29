

class StripeInputModel {
  final String  currency;
  final String amount;

  StripeInputModel({required this.currency, required this.amount,});

toJson() => {
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