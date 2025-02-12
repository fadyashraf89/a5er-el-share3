import 'package:a5er_elshare3/features/Trip/domain/Repositories/TripRepository.dart';

import '../models/trip.dart';

class getActiveTripsStreamUseCase {
  final TripRepository repository;

  getActiveTripsStreamUseCase(this.repository);

  Stream<List<Trip>> getActiveTripsStream(){
    return repository.getActiveTripsStream();
  }
}