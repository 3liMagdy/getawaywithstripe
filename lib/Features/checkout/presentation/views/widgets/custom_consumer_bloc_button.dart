import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_payment_with_getaways/Features/checkout/data/model/stripe_input_model.dart';
import 'package:test_payment_with_getaways/Features/checkout/presentation/manger/cubit/pay_ment_cubit.dart';
import 'package:test_payment_with_getaways/Features/checkout/presentation/manger/cubit/pay_ment_state.dart';
import 'package:test_payment_with_getaways/Features/checkout/presentation/views/thank_you_view.dart';
import 'package:test_payment_with_getaways/core/widgets/custom_button.dart';

class CustomBlocConsumerButton extends StatelessWidget {
  const CustomBlocConsumerButton({super.key, required this.stripeIntent});
  final StripeInputModel stripeIntent;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PayMentCubit, PayMentState>(
      listener: (context, state) {
        if (state is PayMentSuccess) {
          Navigator.of(context).pop();
          Future.microtask(() {
            Navigator.of(context, rootNavigator: true).pushReplacement(
              MaterialPageRoute(builder: (_) => const ThankYouView()),
            );
          });
          context.read<PayMentCubit>().reset();
        } else if (state is PayMentCancel) {
          Navigator.of(context).pop();
          context.read<PayMentCubit>().reset();
        } else if (state is PayMentFailure) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errMessage),
              backgroundColor: Colors.red,
            ),
          );
          context.read<PayMentCubit>().reset();
        }
      },
      builder: (context, state) {
        return CustomButton(
          // 1. Show loading indicator if state is PayMentLoading
          isLoiding: state is PayMentLoading,
          text: 'Continue',
          onTap: () {
            // 2. Prevent multiple taps
            if (state is! PayMentLoading) {
              context.read<PayMentCubit>().checkOut(
                stripeInputModel: stripeIntent,
              );

            }
          },
        );
      },
    );
  }
}
