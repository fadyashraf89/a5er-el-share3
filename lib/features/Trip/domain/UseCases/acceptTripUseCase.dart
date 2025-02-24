import 'package:a5er_elshare3/features/Trip/domain/Repositories/TripRepository.dart';

import '../../../Driver/domain/models/driver.dart';

class acceptTripUseCase {
  final TripRepository repository;

  acceptTripUseCase(this.repository);

  Future<void> acceptTrip(String tripId, Driver driver, String email) async {
    return await repository.acceptTrip(tripId, email, driver);
  }
}