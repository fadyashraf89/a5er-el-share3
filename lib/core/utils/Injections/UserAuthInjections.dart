import 'package:get_it/get_it.dart';

import '../../../features/AuthService/Domain/Repositories/UserAuthRepository.dart';
import '../../../features/AuthService/Domain/UseCases/SignOutUseCase.dart';
import '../../../features/AuthService/Domain/UseCases/fetchUserRoleUseCase.dart';
import '../../../features/AuthService/Domain/UseCases/forgotPasswordUseCase.dart';
import '../../../features/AuthService/Domain/UseCases/getCurrentUserEmailUseCase.dart';
import '../../../features/AuthService/Domain/UseCases/getCurrentUserUidUseCase.dart';
import '../../../features/AuthService/Domain/UseCases/getCurrentUserUseCase.dart';
import '../../../features/AuthService/data/Repositories/UserAuthRepositoryImpl.dart';

class UserAuthInjection {
  void UserAuthInjections(GetIt sl){
    sl.registerLazySingleton<UserAuthRepository>(() => UserAuthRepositoryImpl());
    sl.registerLazySingleton(() => forgotPasswordUseCase(sl<UserAuthRepository>()));
    sl.registerLazySingleton(() => fetchUserRoleUseCase(sl<UserAuthRepository>()));
    sl.registerLazySingleton(() => getCurrentUserEmailUseCase(sl<UserAuthRepository>()));
    sl.registerLazySingleton(() => getCurrentUserUidUseCase(sl<UserAuthRepository>()));
    sl.registerLazySingleton(() => getCurrentUserUseCase(sl<UserAuthRepository>()));
    sl.registerLazySingleton(() => SignOutUseCase(sl<UserAuthRepository>()));
  }
}