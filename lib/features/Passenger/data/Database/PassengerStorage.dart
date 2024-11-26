import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Passenger.dart';

class PassengerStorage {
  Future<void> addPassenger(Passenger passenger) async {
    CollectionReference passengers =
    FirebaseFirestore.instance.collection('Passengers');
    try {
      await passengers.add({
        'email': passenger.email,
        'mobileNumber': passenger.mobileNumber,
        'uid': passenger.uid,
        'role': passenger.role,
        "name": passenger.name
      });
      print("Passenger Added");
    } catch (error) {
      print("Failed to add passenger: $error");
    }
  }
}