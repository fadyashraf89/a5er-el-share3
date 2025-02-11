import 'package:get_it/get_it.dart';

import '../../../features/Driver/data/Repositories/DriverRepositoryImpl.dart';
import '../../../features/Driver/domain/Repositories/DriverRepository.dart';
import '../../../features/Driver/domain/UseCases/AddDriverUseCase.dart';
import '../../../features/Driver/domain/UseCases/FetchDriverDataUseCase.dart';
import '../../../features/Driver/domain/UseCases/UpdateDriverDataUseCase.dart';

class DriverInjection {
  void DriverInjections(GetIt sl){
    sl.registerLazySingleton<DriverRepository>(() => DriverRepositoryImpl());
    sl.registerLazySingleton(() => AddDriverUseCase(sl<DriverRepository>()));
    sl.registerLazySingleton(() => FetchDriverDataUseCase(sl<DriverRepository>()));
    sl.registerLazySingleton(() => UpdateDriverDataUseCase(sl<DriverRepository>()));
  }
}