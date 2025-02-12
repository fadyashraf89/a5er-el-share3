import 'package:a5er_elshare3/features/Trip/domain/Repositories/TripRepository.dart';

import '../models/trip.dart';

class fetchRejectedTripsForUserUseCase {
  final TripRepository repository;

  fetchRejectedTripsForUserUseCase(this.repository);

  Future<List<Trip>> fetchRejectedTripsForUser(String userMail) async {
    return await repository.fetchRejectedTripsForUser(userMail);
  }
}