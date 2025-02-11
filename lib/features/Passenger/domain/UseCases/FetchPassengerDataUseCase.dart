import 'package:a5er_elshare3/features/Passenger/domain/Repositories/PassengerRepository.dart';

import '../models/Passenger.dart';

class FetchPassengerDataUseCase {
  final PassengerRepository passengerRepository;
  FetchPassengerDataUseCase(this.passengerRepository);
  Future<Passenger> fetchPassengerData() async {
    return await passengerRepository.fetchPassengerData();
  }
}