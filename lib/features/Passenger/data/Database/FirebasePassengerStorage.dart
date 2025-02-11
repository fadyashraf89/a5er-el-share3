import 'package:a5er_elshare3/features/Passenger/data/Database/PassengerStorage.dart';

class FirebasePassengerStorage extends PassengerStorage {
  // @override
  // Future<void> addPassenger(PassengerEntity passenger) async {
  //   PassengerRepositoryImpl repositoryImpl = PassengerRepositoryImpl();
  //   repositoryImpl.addPassenger(passenger);
  // }

  // @override
  // Future<Passenger> fetchPassengerData() async {
  //   final user = await authentication.getCurrentUser(); // Assume this method gets the current Firebase user.
  //   if (user == null) throw Exception("User not logged in");
  //
  //   final doc =
  //   await firestore.collection(kPassengersCollection).doc(user.uid).get(); // Fetch user data from Firestore.
  //
  //   if (doc.exists) {
  //     return Passenger.fromMap(doc.data()!);
  //   } else {
  //     throw Exception("User data not found");
  //   }
  // }

  // @override
  // Future<void> updatePassengerData(Map<String, dynamic> updatedData) async {
  //   final user = await authentication.getCurrentUser();
  //   if (user == null) throw Exception("User not logged in");
  //
  //   try {
  //     await firestore
  //         .collection(kPassengersCollection)
  //         .doc(user.uid)
  //         .update(updatedData);
  //     print("Passenger Data Updated Successfully");
  //   } catch (error) {
  //     print("Failed to update passenger: $error");
  //     throw Exception("Failed to update passenger: $error");
  //   }
  // }
}
