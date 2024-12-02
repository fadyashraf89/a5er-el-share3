import 'package:a5er_elshare3/features/Trip/data/models/trip.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../Authentication/data/Database/FirebaseAuthentication.dart';

final User? currentUser = FirebaseAuth.instance.currentUser;
final String? currentEmail = currentUser?.email;

class TripStorage {
  Future<void> addTrip(List<Trip> tripsList) async {
    CollectionReference trips = FirebaseFirestore.instance.collection('Trips');

    for (Trip trip in tripsList) {
      String documentId = trip.passenger?.email ?? ''; // Use a default if email is null

      await trips.doc(documentId).set({
        'trips': FieldValue.arrayUnion([]),
      }, SetOptions(merge: true));

      await trips.doc(documentId).update({
        'trips': FieldValue.arrayUnion(tripsList.map((trip) => trip.toMap()).toList()),
      });
    }
  }

  Future<List<Trip>> fetchTripsForLoggedInUser() async {
    Authentication auth = Authentication();
    try {
      // Get the current user's email
      String? currentEmail = await auth.getCurrentUserEmail();

      if (currentEmail == null) {
        print("No user currently signed in.");
        return []; // Handle case where no user is signed in
      }

      return await fetchTripsForUser(currentEmail);
    } catch (e) {
      print("Error fetching trips for logged-in user: $e");
      return []; // Handle error gracefully
    }
  }

  Future<List<Trip>> fetchTripsForUser(String userEmail) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('Trips')
          .doc(userEmail)
          .get();

      if (documentSnapshot.exists) {
        final data = documentSnapshot.data() as Map<String, dynamic>;
        final List<dynamic> tripDataList = data['trips'] ?? [];

        return tripDataList.map((tripData) {
          return Trip.fromMap(tripData as Map<String, dynamic>);
        }).toList();
      } else {
        print("No trips found for user $userEmail");
        return [];
      }
    } catch (e) {
      print("Error fetching trips for user $userEmail: $e");
      return [];
    }
  }

  Future<List<Trip>> fetchAllTrips() async {
    try {
      // Get all documents in the 'Trips' collection
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Trips')
          .get();

      List<Trip> allTrips = [];

      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final List<dynamic> tripDataList = data['trips'] ?? [];

        // Map each trip data to a Trip object and add it to the list
        allTrips.addAll(
          tripDataList.map((tripData) => Trip.fromMap(tripData as Map<String, dynamic>)),
        );
      }

      return allTrips;
    } catch (e) {
      print("Error fetching trips for all users: $e");
      return [];
    }
  }

}