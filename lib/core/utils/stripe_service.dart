
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:test_payment_with_getaways/Features/checkout/data/model/stripe_input_model.dart';
import 'package:test_payment_with_getaways/Features/checkout/data/model/stripe_retern_model/stripe_retern_model.dart';
import 'package:test_payment_with_getaways/core/utils/api_constants.dart';
import 'package:test_payment_with_getaways/core/utils/api_service.dart';

class StripeService {
  final ApiService api;

  static const String baseUrl = ApiConstants.baseUrl;

  StripeService(this.api);

  Future<StripeReturnModel> createPaymentIntent(StripeInputModel stripeInputModel) async {
    try {
      final response = await api.post(
        url: '$baseUrl/create-payment-intent',
        body: stripeInputModel.toJson(),
      );
      
      if (response.data == null) {
        throw Exception('Server returned empty response');
      }

      final responseModel = StripeReturnModel.fromJson(response.data);
      
      if (responseModel.clientSecret == null) {
        throw Exception('No client_secret found in server response');
      }

      return responseModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> initPaymentSheet({required String paymentIntentClientSecret}) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: 'Ali Magdy Store',
          style: ThemeMode.light,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> presentPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> processPayment(StripeInputModel stripeInputModel) async {
    try {
      // 1. Backend call
      final responseModel = await createPaymentIntent(stripeInputModel);

      // 2. Initialize
      await initPaymentSheet(paymentIntentClientSecret: responseModel.clientSecret!);

      // 3. Present
      await presentPaymentSheet();
    } on StripeException catch (e) {
      // HANDLE CANCELLATION EXPLICITLY
      if (e.error.code == FailureCode.Canceled) {
        throw Exception('UserCanceled');
      }
      throw Exception(e.error.localizedMessage ?? 'Stripe error');
    } catch (e) {
      rethrow;
    }
  }
}