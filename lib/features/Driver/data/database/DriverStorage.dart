import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/driver.dart';

class DriverStorage {
  Future<void> addDriver(Driver driver) async {
    CollectionReference drivers =
    FirebaseFirestore.instance.collection('Drivers');
    try {
      // Use `set` with the UID as the document ID
      await drivers.doc(driver.uid).set({
        'email': driver.email,
        'mobileNumber': driver.mobileNumber,
        'carPlateNumber': driver.carPlateNumber,
        'licenseNumber': driver.licenseNumber,
        'role': driver.role,
        'name': driver.name,
      });
      print("Driver Added");
    } catch (error) {
      print("Failed to add driver: $error");
    }
  }
}
