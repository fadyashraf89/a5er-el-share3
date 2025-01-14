import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";

import "../../../../core/utils/constants.dart";

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> registerWithEmailAndPassword(String emailAddress, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
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

  Future<String> SignInWithEmailAndPassword(String emailAddress, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
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

  Future SignOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

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

  Future<String?> getCurrentUserUid() async {
    try {
      User? user = _auth.currentUser;
      return user?.uid;
    } catch (e) {
      print('Error getting current user UID: $e');
      return null;
    }
  }

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

  Future<User?> getCurrentUser() async {
    try {
      return _auth.currentUser;
    } catch (e) {
      print("Error retrieving current user: $e");
      return null;
    }
  }

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