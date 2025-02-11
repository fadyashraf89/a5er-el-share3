import 'package:get_it/get_it.dart';

import '../../../features/Payment/data/Repositories/PaymentRepositoryImpl.dart';
import '../../../features/Payment/domain/Repositories/PaymentRepository.dart';
import '../../../features/Payment/domain/UseCases/AddCardUseCase.dart';
import '../../../features/Payment/domain/UseCases/CardPaymentUseCase.dart';
import '../../../features/Payment/domain/UseCases/CashPaymentUseCase.dart';
import '../../../features/Payment/domain/UseCases/PointsPaymentUseCase.dart';

class PaymentInjection {
  void PaymentInjections(GetIt sl){
    sl.registerLazySingleton<PaymentRepository>(() => PaymentRepositoryImpl());
    sl.registerLazySingleton(() => AddCardUseCase(sl<PaymentRepository>()));
    sl.registerLazySingleton(() => CashPaymentUseCase(sl<PaymentRepository>()));
    sl.registerLazySingleton(() => CardPaymentUseCase(sl<PaymentRepository>()));
    sl.registerLazySingleton(() => PointsPaymentUseCase(sl<PaymentRepository>()));
  }
}