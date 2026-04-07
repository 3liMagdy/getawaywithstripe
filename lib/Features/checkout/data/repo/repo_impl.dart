import 'package:dartz/dartz.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:test_payment_with_getaways/Features/checkout/data/model/stripe_input_model.dart';
import 'package:test_payment_with_getaways/Features/checkout/domain/repo/repo.dart';
import 'package:test_payment_with_getaways/core/errors/failures.dart';
import 'package:test_payment_with_getaways/core/utils/stripe_service.dart';

class CheckoutRepoImpl implements CheckoutRepo {
  final StripeService stripeService;

  CheckoutRepoImpl(this.stripeService);

  @override
  Future<Either<Failure, void>> makePayment({
    required StripeInputModel stripeInputModel,
  }) async {
    try {
      await stripeService.processPayment(stripeInputModel: stripeInputModel);
      return right(null);
    } on StripeException catch (e) {
      final message = e.error.message ?? 'Payment cancelled or failed';
      final code = e.error.code.toString().toLowerCase();
      if (code.contains('canceled') || code.contains('cancelled')) {
        return left(const UserCanceledFailure());
      }
      return left(ServerFailure(message));
    } catch (e) {
      final message = e.toString();
      if (message.toLowerCase().contains('usercanceled') || message.toLowerCase().contains('canceled')) {
        return left(const UserCanceledFailure());
      }
      return left(ServerFailure(message));
    }
  }
}
