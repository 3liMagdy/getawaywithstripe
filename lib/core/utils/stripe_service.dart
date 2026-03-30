

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:test_payment_with_getaways/Features/checkout/data/model/stripe_input_model.dart';
import 'package:test_payment_with_getaways/Features/checkout/data/model/stripe_retern_model/stripe_retern_model.dart';
import 'package:test_payment_with_getaways/core/api_keys/api_keys.dart';
import 'package:test_payment_with_getaways/core/errors/failures.dart';
import 'package:test_payment_with_getaways/core/utils/api_service.dart';

class StripeService {

  ApiService api ;
  
   StripeService(this.api);
  
  Future<String> createPaymentIntent(StripeInputModel stripeInputModel) async {
  final response = await api.post(
    contentType: Headers.formUrlEncodedContentType,
    url: '/create-payment-intent',
    body: stripeInputModel.toJson(),
  );

  final clientSecret = response.data['client_secret'];
 print("FULL RESPONSE: ${response.data}");

  if (clientSecret == null) {
    throw Exception("client_secret is null → check backend response");
  }

  return clientSecret;
}


  Future<void> initPaymentSheet({required String paymentIntentClientSecret}) async {
  try {



    // 3. Initialize the payment sheet
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        // Main params
        paymentIntentClientSecret: paymentIntentClientSecret,
        merchantDisplayName: 'Ali magdy Store Demo',
      ),
    );
  } catch (e) {
   rethrow;
  }
}


  Future<void> presentPaymentSheet() async {
  try {
    // 4. Display the payment sheet
    await Stripe.instance.presentPaymentSheet();
  } catch (e) {
    rethrow;
  }
}

Future<void> processPayment(StripeInputModel stripeInputModel) async {
  try {
    final clientSecret = await createPaymentIntent(stripeInputModel);

    await initPaymentSheet(
      paymentIntentClientSecret: clientSecret,
    );

    await presentPaymentSheet();
  } catch (e) {
    print("Payment Error: $e");
    rethrow;
  }
}
}