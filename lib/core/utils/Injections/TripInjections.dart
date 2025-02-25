import 'package:get_it/get_it.dart';
import 'package:a5er_elshare3/features/Trip/domain/Repositories/TripRepository.dart';
import 'package:a5er_elshare3/features/Trip/data/Repositories/TripRepositoryImpl.dart';
import 'package:a5er_elshare3/features/Trip/domain/UseCases/addTripUseCase.dart';
import 'package:a5er_elshare3/features/Trip/domain/UseCases/acceptTripUseCase.dart';
import 'package:a5er_elshare3/features/Trip/domain/UseCases/fetchTripsForUserUseCase.dart';
import 'package:a5er_elshare3/features/Trip/domain/UseCases/getActiveTripsStreamUseCase.dart';

class TripInjection {
  void TripInjections(GetIt sl) {
    sl.registerLazySingleton<TripRepository>(() => TripRepositoryImpl());
    sl.registerLazySingleton(() => addTripUseCase(sl<TripRepository>()));
    sl.registerLazySingleton(() => acceptTripUseCase(sl<TripRepository>()));
    sl.registerLazySingleton(() => fetchTripsForUserUseCase(sl<TripRepository>()));
    sl.registerLazySingleton(() => getActiveTripsStreamUseCase(sl<TripRepository>()));
  }
}
