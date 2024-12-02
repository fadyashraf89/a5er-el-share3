import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../Authentication/data/Database/FirebaseAuthentication.dart';
import '../models/Passenger.dart';

class PassengerStorage {
  Future<void> addPassenger(Passenger passenger) async {
    CollectionReference passengers =
    FirebaseFirestore.instance.collection('Passengers');
    try {
      await passengers.doc(passenger.uid).set({
        'email': passenger.email,
        'mobileNumber': passenger.mobileNumber,
        'role': passenger.role,
        'name': passenger.name,
      });
      print("Passenger Added");
    } catch (error) {
      print("Failed to add passenger: $error");
    }
  }

  Future<Passenger> fetchPassengerData() async {
    Authentication authentication = Authentication();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final user = await authentication.getCurrentUser(); // Assume this method gets the current Firebase user.
    if (user == null) throw Exception("User not logged in");

    final doc =
    await firestore.collection('Passengers').doc(user.uid).get(); // Fetch user data from Firestore.

    if (doc.exists) {
      return Passenger.fromMap(doc.data()!);
    } else {
      throw Exception("User data not found");
    }
  }
}
