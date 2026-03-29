


import 'package:dartz/dartz.dart';
import 'package:test_payment_with_getaways/Features/checkout/data/model/stripe_input_model.dart';
import 'package:test_payment_with_getaways/Features/checkout/data/model/stripe_retern_model/stripe_retern_model.dart';
import 'package:test_payment_with_getaways/Features/checkout/domain/repo/repo.dart';
import 'package:test_payment_with_getaways/core/errors/failures.dart';

class ManageCartUseCase {
  final CheckoutRepo repo;
  ManageCartUseCase({required this.repo});

   Future<Either<Failure, void>> makePayment({required StripeInputModel stripeInputModel}) async {
    return await repo.makePayment(stripeInputModel: stripeInputModel);
  }
}