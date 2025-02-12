import 'package:a5er_elshare3/features/Trip/domain/Repositories/TripRepository.dart';

import '../models/trip.dart';

class fetchTripsForUserUseCase {
  final TripRepository repository;

  fetchTripsForUserUseCase(this.repository);

  Future<List<Trip>> fetchTripsForUser(String userMail) async {
    return await repository.fetchTripsForUser(userMail);
  }
}