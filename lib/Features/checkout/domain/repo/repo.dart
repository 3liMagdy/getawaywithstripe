import 'package:dartz/dartz.dart';
import 'package:test_payment_with_getaways/Features/checkout/data/model/stripe_input_model.dart';
import 'package:test_payment_with_getaways/Features/checkout/data/model/stripe_retern_model/stripe_retern_model.dart';
import 'package:test_payment_with_getaways/core/errors/failures.dart';

abstract class CheckoutRepo {
  Future<Either<Failure, void>> makePayment({
    required StripeInputModel stripeInputModel,
  });
}
