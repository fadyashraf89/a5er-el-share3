import 'package:get_it/get_it.dart';

import '../../../features/Login/Data/Repositories/LoginRepositoryImpl.dart';
import '../../../features/Login/Domain/Repositories/LoginRepository.dart';
import '../../../features/Login/Domain/UseCases/SignInWithEmailAndPasswordUseCase.dart';

class LoginInjection {
  void LoginInjections(GetIt sl){
    sl.registerLazySingleton<LoginRepository>(() => LoginRepositoryImpl());
    sl.registerLazySingleton(() => SignInWithEmailAndPasswordUseCase(sl<LoginRepository>()));
  }
}