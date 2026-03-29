import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
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
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ThankYouView()));
        }else if(state is PayMentFailure){
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errMessage)));
        }
      },
      builder: (context, state) {
        return CustomButton(
          isLoiding: state is PayMentLoading ? true : false,
          text: 'Continue',
          onTap:(){
            BlocProvider.of<PayMentCubit>(context).checkOut(stripeInputModel: stripeIntent );
          } 
          );
          
      },
    );
  }
}
