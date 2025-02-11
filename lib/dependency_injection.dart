import 'package:a5er_elshare3/features/Passenger/domain/UseCases/UpdatePassengerDataUseCase.dart';
import 'package:a5er_elshare3/features/Payment/domain/UseCases/CardPaymentUseCase.dart';
import 'package:a5er_elshare3/features/Payment/domain/UseCases/CashPaymentUseCase.dart';
import 'package:a5er_elshare3/features/Payment/domain/UseCases/PointsPaymentUseCase.dart';
import 'package:get_it/get_it.dart';
import 'package:a5er_elshare3/features/Login/Data/Repositories/LoginRepositoryImpl.dart';
import 'package:a5er_elshare3/features/Login/Domain/Repositories/LoginRepository.dart';
import 'package:a5er_elshare3/features/Passenger/data/Repositories/PassengerRepositoryImpl.dart';
import 'package:a5er_elshare3/features/Passenger/domain/Repositories/PassengerRepository.dart';
import 'package:a5er_elshare3/features/Passenger/domain/UseCases/AddPassengerUseCase.dart';
import 'package:a5er_elshare3/features/Passenger/domain/UseCases/FetchPassengerDataUseCase.dart';
import 'package:a5er_elshare3/features/Payment/domain/Repositories/PaymentRepository.dart';
import 'package:a5er_elshare3/features/Payment/domain/UseCases/AddCardUseCase.dart';
import 'package:a5er_elshare3/features/SignUp/Data/Repositories/SignUpRepository.dart';
import 'features/AuthService/Domain/Repositories/UserAuthRepository.dart';
import 'features/Login/Domain/UseCases/SignInWithEmailAndPasswordUseCase.dart';
import 'features/AuthService/Domain/UseCases/SignOutUseCase.dart';
import 'features/AuthService/Domain/UseCases/fetchUserRoleUseCase.dart';
import 'features/AuthService/Domain/UseCases/forgotPasswordUseCase.dart';
import 'features/AuthService/Domain/UseCases/getCurrentUserEmailUseCase.dart';
import 'features/AuthService/Domain/UseCases/getCurrentUserUidUseCase.dart';
import 'features/AuthService/Domain/UseCases/getCurrentUserUseCase.dart';
import 'features/Payment/data/Repositories/PaymentRepositoryImpl.dart';
import 'features/SignUp/Domain/UseCases/registerWithEmailAndPasswordUseCase.dart';
import 'features/AuthService/data/Repositories/UserAuthRepositoryImpl.dart';
import 'features/SignUp/Domain/Repositories/SignUpRepositoryImpl.dart';
final sl = GetIt.instance;
void setupLocator() {
  // Register the repositories
  sl.registerLazySingleton<UserAuthRepository>(() => UserAuthRepositoryImpl());
  sl.registerLazySingleton<LoginRepository>(() => LoginRepositoryImpl());
  sl.registerLazySingleton<SignUpRepository>(() => SignUpRepositoryImpl());
  sl.registerLazySingleton<PaymentRepository>(() => PaymentRepositoryImpl());
  sl.registerLazySingleton<PassengerRepository>(() => PassengerRepositoryImpl());


  // Register the Use Cases
  sl.registerLazySingleton(() => forgotPasswordUseCase(sl<UserAuthRepository>()));
  sl.registerLazySingleton(() => fetchUserRoleUseCase(sl<UserAuthRepository>()));
  sl.registerLazySingleton(() => getCurrentUserEmailUseCase(sl<UserAuthRepository>()));
  sl.registerLazySingleton(() => getCurrentUserUidUseCase(sl<UserAuthRepository>()));
  sl.registerLazySingleton(() => getCurrentUserUseCase(sl<UserAuthRepository>()));
  sl.registerLazySingleton(() => SignOutUseCase(sl<UserAuthRepository>()));
  sl.registerLazySingleton(() => SignInWithEmailAndPasswordUseCase(sl<LoginRepository>()));
  sl.registerLazySingleton(() => registerWithEmailAndPasswordUseCase(sl<SignUpRepository>()));
  sl.registerLazySingleton(() => AddPassengerUseCase(sl<PassengerRepository>()));
  sl.registerLazySingleton(() => FetchPassengerDataUseCase(sl<PassengerRepository>()));
  sl.registerLazySingleton(() => UpdatePassengerDataUseCase(sl<PassengerRepository>()));
  sl.registerLazySingleton(() => AddCardUseCase(sl<PaymentRepository>()));
  sl.registerLazySingleton(() => CashPaymentUseCase(sl<PaymentRepository>()));
  sl.registerLazySingleton(() => CardPaymentUseCase(sl<PaymentRepository>()));
  sl.registerLazySingleton(() => PointsPaymentUseCase(sl<PaymentRepository>()));




}