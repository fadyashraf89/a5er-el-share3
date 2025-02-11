import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../AuthService/data/Database/FirebaseAuthentication.dart';

abstract class PassengerStorage {
  AuthService authentication = AuthService();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  // Future<void> addPassenger(PassengerEntity passenger);

  // Future<Passenger> fetchPassengerData();

  // Future<void> updatePassengerData(Map<String, dynamic> updatedData);
}
