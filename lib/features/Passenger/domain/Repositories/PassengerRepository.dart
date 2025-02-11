import '../../data/Entities/PassengerEntity.dart';
import '../models/Passenger.dart';

abstract class PassengerRepository {
  Future<void> addPassenger(PassengerEntity passenger);
  Future<Passenger> fetchPassengerData();
  Future<void> updatePassengerData(Map<String, dynamic> updatedData);
}