

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:test_payment_with_getaways/Features/checkout/data/model/stripe_input_model.dart';
import 'package:test_payment_with_getaways/Features/checkout/data/model/stripe_retern_model/stripe_retern_model.dart';
import 'package:test_payment_with_getaways/core/api_keys/api_keys.dart';
import 'package:test_payment_with_getaways/core/errors/failures.dart';
import 'package:test_payment_with_getaways/core/utils/api_service.dart';

class StripeService {

  ApiService api = ApiService();
  
   Future<StripeReturnModel> createPaymentSheet(  StripeInputModel stripeInputModel) async {
    try {
      final response = await api.post(
        contentType: Headers.formUrlEncodedContentType,
        url: 'https://your-server.com/create-payment-intent',
        body: stripeInputModel.toJson(),
        token: ApiKeys.stripeSecretKey,
      );
       var responseModel = StripeReturnModel.fromJson(response.data) ;
      return responseModel;
    } catch (e) {
      rethrow;
    }
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

Future<void> processPayment(StripeInputModel stripeInputModel, ) async {
  try {
    // Step 1: Create a payment intent on the server
    StripeReturnModel responseModel = await createPaymentSheet(stripeInputModel);

    // Step 2: Initialize the payment sheet with the client secret
    await initPaymentSheet(paymentIntentClientSecret: responseModel.clientSecret!);

    // Step 3: Present the payment sheet to the user
    await presentPaymentSheet();
  } catch (e) {
    rethrow;
  }
}
}