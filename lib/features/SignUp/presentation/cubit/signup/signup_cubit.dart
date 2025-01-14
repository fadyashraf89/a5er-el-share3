import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../../../../Driver/data/database/FirebaseDriverStorage.dart';
import '../../../../Driver/domain/models/driver.dart';
import '../../../../Passenger/data/Database/FirebasePassengerStorage.dart';
import '../../../../Passenger/domain/models/Passenger.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupInitial());
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign-Up
  Future<void> signUp({
    required String email,
    required String password,
    required String role,
    required String mobileNumber,
    required String name,
    String? licenseNumber,
    String? carPlateNumber,
    String? carModel,
  }) async {
    emit(SignupLoading());
    try {
      String message = await _registerWithEmailAndPassword(email, password);
      if (message.contains('successful')) {
        if (role == 'Passenger') {
          Passenger passenger = Passenger(
            email: email,
            mobileNumber: mobileNumber,
            uid: _auth.currentUser!.uid,
            name: name,
            role: "Passenger",
            points: 0
          );
          FirebasePassengerStorage().addPassenger(passenger);
        } else if (role == 'Driver') {
          Driver driver = Driver(
            email: email,
            mobileNumber: mobileNumber,
            uid: _auth.currentUser!.uid,
            licenseNumber: licenseNumber ?? '',
            carPlateNumber: carPlateNumber ?? '',
            carModel: carModel ?? '',
            name: name,
            role: "Driver",
          );
          FirebaseDriverStorage().addDriver(driver);
        }
        emit(SignupSuccess());
      } else {
        emit(SignupFailure(message: message));
      }
    } catch (e) {
      emit(SignupFailure(message: "Sign-up failed: $e"));
    }
  }

  Future<String> _registerWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return 'Registration successful!';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
      return 'Registration failed. Please try again.';
    } catch (e) {
      return 'An error occurred. Please try again.';
    }
  }
}
