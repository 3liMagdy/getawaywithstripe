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
          // Navigate to success screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ThankYouView()),
          );
        } else if (state is PayMentCancel) {
          // Simply close the bottom sheet on cancellation
          Navigator.of(context).pop();
        } else if (state is PayMentFailure) {
          // Only show error snackbar for REAL failures
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errMessage),
              backgroundColor: Colors.red,
            ),
          );
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
