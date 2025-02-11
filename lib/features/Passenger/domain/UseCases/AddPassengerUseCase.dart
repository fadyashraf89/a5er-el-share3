import 'package:a5er_elshare3/features/Passenger/data/Entities/PassengerEntity.dart';
import 'package:a5er_elshare3/features/Passenger/domain/Repositories/PassengerRepository.dart';

class AddPassengerUseCase {
  final PassengerRepository passengerRepository;
  AddPassengerUseCase(this.passengerRepository);
  Future<void> addPassenger(PassengerEntity passenger) async {
    return await passengerRepository.addPassenger(passenger);
  }
}