import '../Repositories/DriverRepository.dart';

class UpdateDriverDataUseCase {
  final DriverRepository repository;

  UpdateDriverDataUseCase(this.repository);
  Future<void> updateDriverData(Map<String, dynamic> updatedData) async {
    return await repository.updateDriverData(updatedData);
  }

}