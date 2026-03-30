import 'amount_details.dart';
import 'automatic_payment_methods.dart';
import 'metadata.dart';
import 'payment_method_options.dart';

class StripeReturnModel {
 final String clientSecret;

  StripeReturnModel({required this.clientSecret});

  factory StripeReturnModel.fromJson(Map<String, dynamic> json) {
    return StripeReturnModel(
      clientSecret: json['client_secret'],
    );
  }
}
