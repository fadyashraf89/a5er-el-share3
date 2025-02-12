import 'package:a5er_elshare3/features/Trip/domain/Repositories/TripRepository.dart';

import '../../../Driver/domain/models/driver.dart';

class acceptTripUseCase {
  final TripRepository repository;

  acceptTripUseCase(this.repository);

  Future<void> acceptTrip(String userEmail, Map<String, dynamic> tripData, Driver driver) async {
    return await repository.acceptTrip(userEmail, tripData, driver);
  }
}