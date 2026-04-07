import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_payment_with_getaways/Features/checkout/data/model/stripe_input_model.dart';
import 'package:test_payment_with_getaways/Features/checkout/presentation/manger/cubit/pay_ment_cubit.dart';
import 'package:test_payment_with_getaways/Features/checkout/presentation/views/widgets/cart_info_item.dart';
import 'package:test_payment_with_getaways/Features/checkout/presentation/views/widgets/payment_methods_bottom_sheet.dart';
import 'package:test_payment_with_getaways/Features/checkout/presentation/views/widgets/total_price_widget.dart';
import 'package:test_payment_with_getaways/core/utils/service_locator.dart';
import 'package:test_payment_with_getaways/core/widgets/custom_button.dart';

class MyCartViewBody extends StatelessWidget {
  const MyCartViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 18),
          Expanded(child: Image.asset('assets/images/basket_image.png')),
          const SizedBox(height: 25),
          const OrderInfoItem(title: 'Order Subtotal', value: r'42.97$'),
          const SizedBox(height: 3),
          const OrderInfoItem(title: 'Discount', value: r'0$'),
          const SizedBox(height: 3),
          const OrderInfoItem(title: 'Shipping', value: r'8$'),
          const Divider(thickness: 2, height: 34, color: Color(0xffC7C7C7)),
          const TotalPrice(title: 'Total', value: r'$50.97'),
          const SizedBox(height: 16),
          CustomButton(
            text: 'Complete Payment',
            onTap: () {
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              //   return const PaymentDetailsView();
              // }));

              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                builder: (context) {
                  return BlocProvider(
                    create: (context) => getIt<PayMentCubit>(),
                    child: PaymentMethodsBottomSheet(
                      stripeIntent: StripeInputModel(
                        // Stripe expects amount in cents as an INTEGER.
                        // $50.97 -> 50.97 * 100 = 5097
                        amount: 5097,
                        currency: 'USD',
                      ),
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
