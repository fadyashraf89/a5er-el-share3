import 'package:a5er_elshare3/features/AuthService/Domain/Repositories/UserAuthRepository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/utils/Constants/constants.dart';

class UserAuthRepositoryImpl implements UserAuthRepository{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future SignOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  Future<String> forgotPassword(String emailAddress) async {
    try {
      await _auth.sendPasswordResetEmail(email: emailAddress);
      return 'Password reset email sent! Please check your inbox.';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      }
      return 'Failed to send password reset email. Please try again.';
    } catch (e) {
      return 'An error occurred. Please try again.';
    }
  }

  @override
  Future<String?> getCurrentUserUid() async {
    try {
      User? user = _auth.currentUser;
      return user?.uid;
    } catch (e) {
      print('Error getting current user UID: $e');
      return null;
    }
  }

  @override
  Future<String?> fetchUserRole(String userId) async {
    try {
      final passengerDoc = await FirebaseFirestore.instance
          .collection(kPassengersCollection)
          .doc(userId)
          .get();

      if (passengerDoc.exists) {
        print("Passenger document exists: ${passengerDoc.exists}");
        print("Passenger document data: ${passengerDoc.data()}");
        return passengerDoc.data()?['role'];
      }

      final driverDoc = await FirebaseFirestore.instance
          .collection(kDriversCollection)
          .doc(userId)
          .get();

      if (driverDoc.exists) {
        print("Driver document exists: ${driverDoc.exists}");
        print("Driver document data: ${driverDoc.data()}");
        return driverDoc.data()?['role']; // Return 'Driver' role
      }

      print("No document found for user ID: $userId");
      return null;
    } catch (e) {
      print("Error fetching user role: $e");
      return null;
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      return _auth.currentUser;
    } catch (e) {
      print("Error retrieving current user: $e");
      return null;
    }
  }

  @override
  Future<String?> getCurrentUserEmail() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        return user.email;
      } else {
        print("No user is currently signed in.");
        return null;
      }
    } catch (e) {
      print("Error getting current user email: $e");
      return null;
    }
  }
}