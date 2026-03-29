 


 import 'package:bloc/bloc.dart';
import 'package:test_payment_with_getaways/Features/checkout/data/model/stripe_input_model.dart';
import 'package:test_payment_with_getaways/Features/checkout/domain/usecase/manage_cart_use_case.dart';
import 'package:test_payment_with_getaways/Features/checkout/presentation/manger/cubit/pay_ment_state.dart';

class PayMentCubit extends Cubit<PayMentState> {

 ManageCartUseCase manageCartUseCase;
 PayMentCubit({required this.manageCartUseCase}) : super(PayMentInitial());
   Future checkOut({required StripeInputModel stripeInputModel}) async {
    emit(PayMentLoading());
    try {
      final result = await manageCartUseCase.makePayment(stripeInputModel: stripeInputModel);
      result.fold(
        (failure) => emit(PayMentFailure(failure.toString())),
        (_) => emit(PayMentSuccess()),
      );
    } catch (e) {
      emit(PayMentFailure(e.toString()));
    }
  }
  } 