import 'package:a5er_elshare3/features/Trip/domain/Repositories/TripRepository.dart';

import '../models/trip.dart';

class addTripUseCase {
  final TripRepository repository;

  addTripUseCase(this.repository);

  Future<void> addTrip(List<Trip> tripsList) async{
    return await repository.addTrip(tripsList);
  }
}