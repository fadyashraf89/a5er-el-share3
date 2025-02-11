import 'package:get_it/get_it.dart';

import '../../../features/Passenger/data/Repositories/PassengerRepositoryImpl.dart';
import '../../../features/Passenger/domain/Repositories/PassengerRepository.dart';
import '../../../features/Passenger/domain/UseCases/AddPassengerUseCase.dart';
import '../../../features/Passenger/domain/UseCases/FetchPassengerDataUseCase.dart';
import '../../../features/Passenger/domain/UseCases/UpdatePassengerDataUseCase.dart';

class PassengerInjection {
  void PassengerInjections(GetIt sl){
    sl.registerLazySingleton<PassengerRepository>(() => PassengerRepositoryImpl());
    sl.registerLazySingleton(() => AddPassengerUseCase(sl<PassengerRepository>()));
    sl.registerLazySingleton(() => FetchPassengerDataUseCase(sl<PassengerRepository>()));
    sl.registerLazySingleton(() => UpdatePassengerDataUseCase(sl<PassengerRepository>()));
  }
}