import 'package:get_it/get_it.dart';
import 'package:test_payment_with_getaways/Features/checkout/data/repo/repo_impl.dart';
import 'package:test_payment_with_getaways/Features/checkout/domain/repo/repo.dart';
import 'package:test_payment_with_getaways/Features/checkout/domain/usecase/manage_cart_use_case.dart';
import 'package:test_payment_with_getaways/Features/checkout/presentation/manger/cubit/pay_ment_cubit.dart';
import 'package:test_payment_with_getaways/core/utils/api_service.dart';
import 'package:test_payment_with_getaways/core/utils/stripe_service.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  getIt.registerLazySingleton<ApiService>(() => ApiService());
  getIt.registerLazySingleton<StripeService>(
    () => StripeService(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<CheckoutRepo>(
    () => CheckoutRepoImpl(getIt<StripeService>()),
  );
  getIt.registerLazySingleton<ManageCartUseCase>(
    () => ManageCartUseCase(repo: getIt<CheckoutRepo>()),
  );
  getIt.registerFactory<PayMentCubit>(
    () => PayMentCubit(manageCartUseCase: getIt<ManageCartUseCase>()),
  );
}
