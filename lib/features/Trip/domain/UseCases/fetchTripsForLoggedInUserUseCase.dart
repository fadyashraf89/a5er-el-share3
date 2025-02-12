import 'package:a5er_elshare3/features/Trip/domain/Repositories/TripRepository.dart';

import '../models/trip.dart';

class fetchTripsForLoggedInUserUseCase {
  final TripRepository repository;

  fetchTripsForLoggedInUserUseCase(this.repository);

  Future<List<Trip>> fetchTripsForLoggedInUser() async {
    return await repository.fetchTripsForLoggedInUser();
  }
}