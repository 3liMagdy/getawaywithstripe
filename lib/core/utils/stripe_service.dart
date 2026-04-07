import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:test_payment_with_getaways/Features/checkout/data/model/ephemeral_model/ephemeral_model.dart';
import 'package:test_payment_with_getaways/Features/checkout/data/model/stripe_input_model.dart';
import 'package:test_payment_with_getaways/core/utils/api_service.dart';
import 'package:test_payment_with_getaways/core/utils/customer_storage.dart';

class StripeService {
  final ApiService api;
  final CustomerStorage storage = CustomerStorage();

  StripeService(this.api);

  Future<String> _getOrCreateCustomerId() async {
    final savedCustomerId = await storage.getCustomerId();
    if (savedCustomerId != null && savedCustomerId.isNotEmpty) {
      return savedCustomerId;
    }

    final customerId = await createCustomer();
    await storage.saveCustomerId(customerId);
    return customerId;
  }

  Future<String> createCustomer() async {
    final response = await api.post(url: '/create-customer', body: {});
    return response.data['customerId'] as String;
  }

  Future<EphemeralModel> createEphemeralKey(String customerId) async {
    final response = await api.post(
      url: '/ephemeral-key',
      body: {
        'customerId': customerId,
      },
    );

    return EphemeralModel.fromJson(response.data);
  }

  Future<String> createPaymentIntent({
    required int amount,
    required String currency,
    required String customerId,
  }) async {
    final response = await api.post(
      contentType: Headers.formUrlEncodedContentType,
      url: '/create-payment-intent',
      body: {
        'amount': amount,
        'currency': currency,
        'customerId': customerId,
        'setup_future_usage': 'off_session',
      },
    );

    final clientSecret = response.data['client_secret'];
    if (clientSecret == null) {
      throw Exception('client_secret is null → check backend response');
    }

    return clientSecret as String;
  }

  Future<void> initPaymentSheet({
    required String paymentIntentClientSecret,
    required String customerId,
    required String ephemeralKey,
  }) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntentClientSecret,
        merchantDisplayName: 'Ali magdy Store Demo',
        customerId: customerId,
        customerEphemeralKeySecret: ephemeralKey,
        // The payment sheet will show saved cards for this customer automatically.
      ),
    );
  }

  Future<void> presentPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> processPayment({
    required StripeInputModel stripeInputModel,
  }) async {
    try {
      final customerId = await _getOrCreateCustomerId();
      print("Customer ID: $customerId");
      final ephemeral = await createEphemeralKey(customerId);

      if (ephemeral.secret == null || ephemeral.secret!.isEmpty) {
        throw Exception('Ephemeral key secret is missing');
      }

      final clientSecret = await createPaymentIntent(
        amount: stripeInputModel.amount,
        currency: stripeInputModel.currency,
        customerId: customerId,
      );

      await initPaymentSheet(
        paymentIntentClientSecret: clientSecret,
        customerId: customerId,
        ephemeralKey: ephemeral.secret!,
      );
      
      await presentPaymentSheet();
    } catch (e) {
      print('Payment Error: $e');
      rethrow;
    }
  }
}
