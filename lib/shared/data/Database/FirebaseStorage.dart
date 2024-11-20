import 'package:a5er_elshare3/shared/data/models/Passenger.dart';
import 'package:a5er_elshare3/shared/data/models/driver.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Storage {
  Future<void> addPassenger(Passenger passenger) async {
    CollectionReference passengers =
    FirebaseFirestore.instance.collection('Passengers');
    try {
      await passengers.add({
        'email': passenger.email,
        'mobileNumber': passenger.mobileNumber,
        'uid': passenger.uid,
        'role': passenger.role
      });
      print("Passenger Added");
    } catch (error) {
      print("Failed to add passenger: $error");
    }
  }

  Future<void> addDriver(Driver driver) async {
    CollectionReference drivers =
    FirebaseFirestore.instance.collection('Drivers');
    try {
      await drivers.add({
        'email': driver.email,
        'mobileNumber': driver.mobileNumber,
        'uid': driver.uid,
        'carPlateNumber': driver.carPlateNumber,
        'licenseNumber': driver.licenseNumber,
        'role': driver.role
      });
      print("Driver Added");
    } catch (error) {
      print("Failed to add driver: $error");
    }
  }
}
