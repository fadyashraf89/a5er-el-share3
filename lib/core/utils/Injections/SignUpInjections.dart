import 'package:get_it/get_it.dart';

import '../../../features/SignUp/Data/Repositories/SignUpRepository.dart';
import '../../../features/SignUp/Domain/Repositories/SignUpRepositoryImpl.dart';
import '../../../features/SignUp/Domain/UseCases/registerWithEmailAndPasswordUseCase.dart';

class SignUpInjection {
  void SignUpInjections(GetIt sl){
    sl.registerLazySingleton<SignUpRepository>(() => SignUpRepositoryImpl());
    sl.registerLazySingleton(() => registerWithEmailAndPasswordUseCase(sl<SignUpRepository>()));
  }
}