import 'package:a5er_elshare3/features/Login/Data/Repositories/LoginRepositoryImpl.dart';
import 'package:a5er_elshare3/features/Login/Domain/Repositories/LoginRepository.dart';
import 'package:a5er_elshare3/features/SignUp/Data/Repositories/SignUpRepository.dart';
import 'package:get_it/get_it.dart';
import 'features/AuthService/Domain/Repositories/UserAuthRepository.dart';
import 'features/Login/Domain/UseCases/SignInWithEmailAndPasswordUseCase.dart';
import 'features/AuthService/Domain/UseCases/SignOutUseCase.dart';
import 'features/AuthService/Domain/UseCases/fetchUserRoleUseCase.dart';
import 'features/AuthService/Domain/UseCases/forgotPasswordUseCase.dart';
import 'features/AuthService/Domain/UseCases/getCurrentUserEmailUseCase.dart';
import 'features/AuthService/Domain/UseCases/getCurrentUserUidUseCase.dart';
import 'features/AuthService/Domain/UseCases/getCurrentUserUseCase.dart';
import 'features/SignUp/Domain/UseCases/registerWithEmailAndPasswordUseCase.dart';
import 'features/AuthService/data/Repositories/UserAuthRepositoryImpl.dart';
import 'features/SignUp/Domain/Repositories/SignUpRepositoryImpl.dart';
final sl = GetIt.instance;
void setupLocator() {
  // Register the repositories
  sl.registerLazySingleton<UserAuthRepository>(() => UserAuthRepositoryImpl());
  sl.registerLazySingleton<LoginRepository>(() => LoginRepositoryImpl());
  sl.registerLazySingleton<SignUpRepository>(() => SignUpRepositoryImpl());


  // Register the Use Cases
  sl.registerLazySingleton(() => forgotPasswordUseCase(sl<UserAuthRepository>()));
  sl.registerLazySingleton(() => fetchUserRoleUseCase(sl<UserAuthRepository>()));
  sl.registerLazySingleton(() => getCurrentUserEmailUseCase(sl<UserAuthRepository>()));
  sl.registerLazySingleton(() => getCurrentUserUidUseCase(sl<UserAuthRepository>()));
  sl.registerLazySingleton(() => getCurrentUserUseCase(sl<UserAuthRepository>()));
  sl.registerLazySingleton(() => SignOutUseCase(sl<UserAuthRepository>()));
  sl.registerLazySingleton(() => SignInWithEmailAndPasswordUseCase(sl<LoginRepository>()));
  sl.registerLazySingleton(() => registerWithEmailAndPasswordUseCase(sl<SignUpRepository>()));
}