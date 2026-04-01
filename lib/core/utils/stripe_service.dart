import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:test_payment_with_getaways/Features/checkout/data/model/stripe_input_model.dart';
import 'package:test_payment_with_getaways/Features/checkout/data/model/stripe_retern_model/stripe_retern_model.dart';
import 'package:test_payment_with_getaways/core/api_keys/api_keys.dart';
import 'package:test_payment_with_getaways/core/errors/failures.dart';
import 'package:test_payment_with_getaways/core/utils/api_service.dart';
import 'package:test_payment_with_getaways/core/utils/customer_storage.dart';

class StripeService {
  ApiService api;
  final CustomerStorage storage = CustomerStorage();

  StripeService(this.api);

  Future<String> createCustomer() async {
  final response = await api.post(
    url: '/create-customer',
    body: {},
  );

  return response.data['customerId'];
}
  
  Future<Map<String, dynamic>> createEphemeralKey(String customerId) async {
  final response = await api.post(
    url: '/ephemeral-key',
    body: {
      "customerId": customerId,
    },
  );

  return response.data;
}

  Future<String> createPaymentIntent(StripeInputModel stripeInputModel) async {
    final response = await api.post(
      contentType: Headers.formUrlEncodedContentType,
      url: '/create-payment-intent',
      body: stripeInputModel.toJson(),
    );

    final clientSecret = response.data['client_secret'];

    if (clientSecret == null) {
      throw Exception("client_secret is null → check backend response");
    }

    return clientSecret;
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
    ),
  );
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
   
    String? customerId = await storage.getCustomerId();

   // check if customerId exists, if not create a new customer and save the id
    if (customerId == null) {
      customerId = await createCustomer();
      await storage.saveCustomerId(customerId);
    }

    // 3. ephemeral key
    final ephemeralKeyRes = await createEphemeralKey(customerId);
    final ephemeralKey = ephemeralKeyRes['secret'];

    // 4. payment intent
    final updatedModel = StripeInputModel(
      amount: stripeInputModel.amount,
      currency: stripeInputModel.currency,
      customer: customerId,
    );

    final clientSecret = await createPaymentIntent(updatedModel);

    // 5. init payment sheet
    await initPaymentSheet(
      paymentIntentClientSecret: clientSecret,
      customerId: customerId,
      ephemeralKey: ephemeralKey,
    );

    // 6. عرض الدفع
    await presentPaymentSheet();

  } catch (e) {
    print("Payment Error: $e");
    rethrow;
  }
}
}
