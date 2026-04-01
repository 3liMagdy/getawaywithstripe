import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:test_payment_with_getaways/Features/checkout/data/model/stripe_retern_model/stripe_retern_model.dart';

abstract class PayMentState {}

final class PayMentInitial extends PayMentState {}

final class PayMentLoading extends PayMentState {}

final class PayMentSuccess extends PayMentState {}

final class PayMentFailure extends PayMentState {
  final String errMessage;
  PayMentFailure(this.errMessage);
}

final class PayMentCancel extends PayMentState {}
