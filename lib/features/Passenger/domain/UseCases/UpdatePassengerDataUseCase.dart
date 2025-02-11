import 'package:a5er_elshare3/features/Passenger/domain/Repositories/PassengerRepository.dart';
class UpdatePassengerDataUseCase {
  final PassengerRepository passengerRepository;
  UpdatePassengerDataUseCase(this.passengerRepository);
  Future<void> updatePassengerData(Map<String, dynamic> updatedData) async {
    return await passengerRepository.updatePassengerData(updatedData);
  }
}