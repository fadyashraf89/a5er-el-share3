import 'package:a5er_elshare3/features/Driver/data/Entities/DriverEntity.dart';
import 'package:a5er_elshare3/features/Driver/domain/Repositories/DriverRepository.dart';

class AddDriverUseCase {
  final DriverRepository repository;

  AddDriverUseCase(this.repository);
  Future<void> addDriver(DriverEntity driver) async {
    return await repository.addDriver(driver);
  }
}