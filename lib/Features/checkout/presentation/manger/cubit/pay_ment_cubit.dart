import 'package:bloc/bloc.dart';
import 'package:test_payment_with_getaways/Features/checkout/data/model/stripe_input_model.dart';
import 'package:test_payment_with_getaways/Features/checkout/domain/usecase/manage_cart_use_case.dart';
import 'package:test_payment_with_getaways/Features/checkout/presentation/manger/cubit/pay_ment_state.dart';
import 'package:test_payment_with_getaways/core/errors/failures.dart';

class PayMentCubit extends Cubit<PayMentState> {
  final ManageCartUseCase manageCartUseCase;

  PayMentCubit({required this.manageCartUseCase}) : super(PayMentInitial());

  Future<void> checkOut({required StripeInputModel stripeInputModel}) async {
    if (isClosed) return;
    // 1. Prevent double emission or multiple requests if UI didn't disable button
    if (state is PayMentLoading) return;

    emit(PayMentLoading());

    try {
      final result = await manageCartUseCase.makePayment(
        stripeInputModel: stripeInputModel,
      );

      // 2. Fold response from Dartz (Clean Architecture Result)
      result.fold(
        (failure) {
          if (!isClosed) {
            if (failure is UserCanceledFailure) {
              emit(PayMentCancel());
            } else {
              emit(PayMentFailure(failure.errMessage));
            }
          }
        },
        (_) {
          if (!isClosed) emit(PayMentSuccess());
        },
      );
    } catch (e) {
      // 3. Robust Error Handling: Ensure we don't emit after cubit is closed
      if (!isClosed) {
        emit(PayMentFailure(e.toString().replaceAll('Exception: ', '')));
      }
    }
  }

  @override
  void onChange(Change<PayMentState> change) {
    debugPrint(change.toString());
    super.onChange(change);
  }
}

// Helper to make debugPrint available if not imported
void debugPrint(String message) => print(message);
