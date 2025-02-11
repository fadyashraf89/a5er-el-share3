import 'package:a5er_elshare3/features/AuthService/Domain/UseCases/getCurrentUserUseCase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/utils/constants.dart';
import '../../../../dependency_injection.dart';
import '../../domain/Repositories/PassengerRepository.dart';
import '../../domain/models/Passenger.dart';
import '../Entities/PassengerEntity.dart';

class PassengerRepositoryImpl implements PassengerRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Future<void> addPassenger(PassengerEntity passenger) async {
    CollectionReference passengers =
    FirebaseFirestore.instance.collection(kPassengersCollection);
    try {
      await passengers.doc(passenger.uid).set({
        'email': passenger.email,
        'mobileNumber': passenger.mobileNumber,
        'role': passenger.role,
        'name': passenger.name,
        'points': passenger.points,
        'uid': passenger.uid
      });
      print("Passenger Added");
    } catch (error) {
      print("Failed to add passenger: $error");
    }
  }

  @override
  Future<Passenger> fetchPassengerData() async {
    getCurrentUserUseCase getcurrentuser = sl<getCurrentUserUseCase>();
    final user = await getcurrentuser.getCurrentUser(); // Assume this method gets the current Firebase user.
    if (user == null) throw Exception("User not logged in");

    final doc =
    await firestore.collection(kPassengersCollection).doc(user.uid).get(); // Fetch user data from Firestore.

    if (doc.exists) {
      return Passenger.fromMap(doc.data()!);
    } else {
      throw Exception("User data not found");
    }
  }

  @override
  Future<void> updatePassengerData(Map<String, dynamic> updatedData) async {
    getCurrentUserUseCase getcurrentuser = sl<getCurrentUserUseCase>();
    final user = await getcurrentuser.getCurrentUser();
    if (user == null) throw Exception("User not logged in");

    try {
      await firestore
          .collection(kPassengersCollection)
          .doc(user.uid)
          .update(updatedData);
      print("Passenger Data Updated Successfully");
    } catch (error) {
      print("Failed to update passenger: $error");
      throw Exception("Failed to update passenger: $error");
    }
  }

}