import 'package:a5er_elshare3/features/Driver/domain/Repositories/DriverRepository.dart';
import 'package:a5er_elshare3/features/Driver/domain/models/driver.dart';

class FetchDriverDataUseCase {
  final DriverRepository repository;
  FetchDriverDataUseCase(this.repository);
  Future<Driver> fetchDriverData() async {
    return await repository.fetchDriverData();
  }
}
