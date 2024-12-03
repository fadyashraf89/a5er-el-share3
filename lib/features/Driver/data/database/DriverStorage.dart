import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../Authentication/data/Database/FirebaseAuthentication.dart';
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
        'carModel': driver.carModel
      });
      print("Driver Added");
    } catch (error) {
      print("Failed to add driver: $error");
    }
  }

  Future<Driver> fetchDriverData() async {
    Authentication authentication = Authentication();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final user = await authentication.getCurrentUser(); // Assume this method gets the current Firebase user.
    if (user == null) throw Exception("User not logged in");

    final doc =
    await firestore.collection('Drivers').doc(user.uid).get(); // Fetch user data from Firestore.

    if (doc.exists) {
      return Driver.fromMap(doc.data()!);
    } else {
      throw Exception("User data not found");
    }
  }

}
