import 'package:a5er_elshare3/features/Passenger/data/Database/PassengerStorage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/Passenger.dart';

class FirebasePassengerStorage extends PassengerStorage {
  @override
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

  @override
  Future<Passenger> fetchPassengerData() async {
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

  @override
  Future<void> updatePassengerData(Map<String, dynamic> updatedData) async {
    final user = await authentication.getCurrentUser();
    if (user == null) throw Exception("User not logged in");

    try {
      await firestore
          .collection('Passengers')
          .doc(user.uid)
          .update(updatedData); // Use Firestore's `update` method
      print("Passenger Data Updated Successfully");
    } catch (error) {
      print("Failed to update passenger: $error");
      throw Exception("Failed to update passenger: $error");
    }
  }
}
