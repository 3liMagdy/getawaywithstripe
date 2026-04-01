import 'package:dartz/dartz.dart';
import 'package:test_payment_with_getaways/Features/checkout/data/model/stripe_input_model.dart';
import 'package:test_payment_with_getaways/Features/checkout/data/model/stripe_retern_model/stripe_retern_model.dart';
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
      await stripeService.processPayment(stripeInputModel);
      return right(null);
    } catch (e) {
      if (e.toString().contains('UserCanceled')) {
        return left(const UserCanceledFailure());
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
