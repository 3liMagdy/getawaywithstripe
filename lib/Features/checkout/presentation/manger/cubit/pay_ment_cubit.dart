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
    if (state is PayMentLoading) return;

    emit(PayMentLoading());

    try {
      final result = await manageCartUseCase.makePayment(
        stripeInputModel: stripeInputModel,
      );

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
      if (!isClosed) {
        emit(PayMentFailure(e.toString().replaceAll('Exception: ', '')));
      }
    }
  }

  void reset() {
    if (!isClosed) {
      emit(PayMentInitial());
    }
  }

  @override
  void onChange(Change<PayMentState> change) {
    debugPrint(change.toString());
    super.onChange(change);
  }
}

void debugPrint(String message) => print(message);
