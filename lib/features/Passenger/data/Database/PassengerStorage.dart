import 'package:a5er_elshare3/features/Passenger/data/Entities/PassengerEntity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../AuthService/data/Database/FirebaseAuthentication.dart';
import '../../domain/models/Passenger.dart';

abstract class PassengerStorage {
  AuthService authentication = AuthService();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<void> addPassenger(PassengerEntity passenger);

  Future<Passenger> fetchPassengerData();

  Future<void> updatePassengerData(Map<String, dynamic> updatedData);
}
