import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;

      // Check if the user is signed in
      if (user != null) {
        return user.email; // Return the user's email address
      } else {
        print("No user is currently signed in.");
        return null; // Handle case where no user is signed in
      }
    } catch (e) {
      print("Error getting current user email: $e");
      return null; // Handle any error gracefully
    }
  }
}