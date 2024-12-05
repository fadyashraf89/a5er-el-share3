import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../../../Driver/data/database/DriverStorage.dart';
import '../../../../Driver/domain/models/driver.dart';
import '../../../../Passenger/data/Database/PassengerStorage.dart';
import '../../../../Passenger/domain/models/Passenger.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthCubit() : super(AuthInitial());

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
    emit(AuthLoading());
    try {
      String message = await _registerWithEmailAndPassword(email, password);
      if (message.contains('successful')) {
        // Perform role-specific operations
        if (role == 'Passenger') {
          Passenger passenger = Passenger(
            email: email,
            mobileNumber: mobileNumber,
            uid: _auth.currentUser!.uid,
            name: name,
            role: "Passenger",
          );
          PassengerStorage().addPassenger(passenger);
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
          DriverStorage().addDriver(driver);
        }
        emit(AuthSuccess());
      } else {
        emit(AuthFailure(message: message));
      }
    } catch (e) {
      emit(AuthFailure(message: "Sign-up failed: $e"));
    }
  }

  // Sign-In
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      String message = await _signInWithEmailAndPassword(email, password);
      if (message.contains('successful')) {
        String? uid = _auth.currentUser?.uid;
        if (uid != null) {
          // Fetch user role and emit success
          String? role = await fetchUserRole(uid);
          emit(AuthSuccess(role: role));
        } else {
          emit(AuthFailure(message: "Failed to get user UID"));
        }
      } else {
        emit(AuthFailure(message: message));
      }
    } catch (e) {
      emit(AuthFailure(message: "Sign-in failed: $e"));
    }
  }

  // Sign-Out
  Future<void> signOut() async {
    emit(AuthLoading());
    try {
      await _auth.signOut();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthFailure(message: "Sign-out failed: $e"));
    }
  }

  // Firebase Auth Operations
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

  Future<String> _signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return 'Sign-in successful!';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      }
      return 'Sign-in failed. Please try again.';
    } catch (e) {
      return 'An error occurred. Please try again.';
    }
  }

  Future<String?> fetchUserRole(String userId) async {
    try {
      // Fetch from Passengers collection
      final passengerDoc = await FirebaseFirestore.instance
          .collection('Passengers')
          .doc(userId)
          .get();

      if (passengerDoc.exists) {
        print("Passenger document exists: ${passengerDoc.exists}");
        print("Passenger document data: ${passengerDoc.data()}");
        return passengerDoc.data()?['role']; // Return 'Passenger' role
      }

      // Fetch from Drivers collection if not found in Passengers
      final driverDoc = await FirebaseFirestore.instance
          .collection('Drivers')
          .doc(userId)
          .get();

      if (driverDoc.exists) {
        print("Driver document exists: ${driverDoc.exists}");
        print("Driver document data: ${driverDoc.data()}");
        return driverDoc.data()?['role']; // Return 'Driver' role
      }

      // Log if neither document is found
      print("No document found for user ID: $userId");
      return null; // User not found in both collections
    } catch (e) {
      print("Error fetching user role: $e");
      return null;
    }
  }
}
