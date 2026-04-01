import 'package:flutter/material.dart';
import 'package:test_payment_with_getaways/Features/checkout/data/model/stripe_input_model.dart';
import 'package:test_payment_with_getaways/Features/checkout/presentation/views/widgets/custom_consumer_bloc_button.dart';
import 'package:test_payment_with_getaways/Features/checkout/presentation/views/widgets/payment_methods_list_view.dart';
import 'package:test_payment_with_getaways/core/widgets/custom_button.dart';

class PaymentMethodsBottomSheet extends StatelessWidget {
  const PaymentMethodsBottomSheet({super.key, required this.stripeIntent});
  final StripeInputModel stripeIntent;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          const PaymentMethodsListView(),
          const SizedBox(height: 32),
          CustomBlocConsumerButton(stripeIntent: stripeIntent),
        ],
      ),
    );
  }
}
