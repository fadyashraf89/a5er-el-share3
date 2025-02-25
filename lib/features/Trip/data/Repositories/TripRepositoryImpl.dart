import 'package:a5er_elshare3/features/Passenger/domain/UseCases/FetchPassengerDataUseCase.dart';
import 'package:a5er_elshare3/features/Trip/domain/Repositories/TripRepository.dart';
import 'package:a5er_elshare3/core/utils/Injections/dependency_injection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../Driver/domain/models/driver.dart';
import '../../domain/models/trip.dart';
class TripRepositoryImpl implements TripRepository{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> addTrip(List<Trip> tripsList) async {
    final passenger = await sl<FetchPassengerDataUseCase>().fetchPassengerData();
    final String? currentEmail = passenger.email;
    CollectionReference tripsCollection = FirebaseFirestore.instance.collection("trips"),
                        ActiveTripsCollection = FirebaseFirestore.instance.collection('Active Trips');
    if (currentEmail == null || currentEmail.isEmpty) {
      throw Exception("Passenger email is null or empty.");
    }


    await tripsCollection.doc(currentEmail).set({
      'trips': FieldValue.arrayUnion([]),
    }, SetOptions(merge: true));

    await tripsCollection.doc(currentEmail).update({
      'trips': FieldValue.arrayUnion(
        tripsList.map((trip) => trip.toMap()).toList(),
      ),
    });

    await ActiveTripsCollection.add({
      'trips': FieldValue.arrayUnion(
        tripsList.map((trip) => trip.toMap()).toList(),
      ),
    },);


  }

  @override
  Future<void> acceptTrip(String tripId, String userEmail, Driver driver) async {
    return _firestore.runTransaction((transaction) async {
      final userTripDoc = _firestore.collection('trips').doc(userEmail);
      final tripSnapshot = await transaction.get(userTripDoc);

      if (!tripSnapshot.exists) throw Exception("User's trip document not found.");
      List<dynamic> trips = List.from(tripSnapshot.data()?["trips"] ?? []);

      final tripIndex = trips.indexWhere((trip) => trip["id"] == tripId);
      if (tripIndex != -1) {
        trips[tripIndex]["Status"] = "accepted";
        trips[tripIndex]["driver"] = driver.toMap();
        transaction.update(userTripDoc, {"trips": trips});
        print("Trip $tripId accepted and driver assigned in user trips.");
      }

      final activeTripsQuery = await _firestore.collection("Active Trips").get();

      for (var doc in activeTripsQuery.docs) {
        List<dynamic> activeTrips = List.from(doc.data()["trips"] ?? []);

        final activeTripIndex = activeTrips.indexWhere((trip) => trip["id"] == tripId);
        if (activeTripIndex != -1) {
          activeTrips[activeTripIndex]["Status"] = "accepted";
          activeTrips[activeTripIndex]["driver"] = driver.toMap();
          transaction.update(doc.reference, {"trips": activeTrips});
          print("Trip $tripId accepted in Active Trips collection.");
          break;
        }
      }
    });
  }

  @override
  Future<List<Trip>> fetchTripsForUser(String userEmail) async {
    final docSnapshot = await _firestore.collection('trips').doc(userEmail).get();

    if (!docSnapshot.exists || docSnapshot.data() == null) {
      return [];
    }

    final data = docSnapshot.data();
    final tripsList = data?['trips'] as List<dynamic>? ?? [];

    return tripsList.map((trip) => Trip.fromMap(trip as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> expireTrip(String tripId, String userEmail) async {
    return _firestore.runTransaction((transaction) async {
      final userTripDoc = _firestore.collection('trips').doc(userEmail);
      final tripSnapshot = await transaction.get(userTripDoc);

      if (!tripSnapshot.exists) throw Exception("Trip not found in user trips.");
      List<dynamic> trips = List.from(tripSnapshot.data()?["trips"] ?? []);
      final tripIndex = trips.indexWhere((trip) => trip["id"] == tripId);
      if (tripIndex != -1) {
        trips[tripIndex]["Status"] = "expired"; // Update status in-place
        transaction.update(userTripDoc, {"trips": trips});
        print("Trip $tripId marked as expired in user trips.");
      }
      final activeTripsQuery = await _firestore.collection("Active Trips").get();

      for (var doc in activeTripsQuery.docs) {
        List<dynamic> activeTrips = List.from(doc.data()["trips"] ?? []);
        final activeTripIndex = activeTrips.indexWhere((trip) => trip["id"] == tripId);
        if (activeTripIndex != -1) {
          activeTrips.removeAt(activeTripIndex);
          transaction.update(doc.reference, {"trips": activeTrips});
          print("Trip $tripId removed from Active Trips collection.");
          break;
        }
      }
    });
  }

  @override
  Future<Trip> fetchTripById(String tripId) async {
    final tripDoc = await _firestore.collection('trips').doc(tripId).get();
    if (!tripDoc.exists) throw Exception("Trip not found.");
    return Trip.fromMap(tripDoc.data()!);
  }

  @override
  Stream<List<Trip>> getActiveTripsStream() {
    return FirebaseFirestore.instance
        .collection("Active Trips")
        .snapshots()
        .map((snapshot) {
      List<Trip> activeTrips = [];

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final List<dynamic> trips = data['trips'] ?? [];

        for (var tripData in trips) {
          if (tripData is Map<String, dynamic> && tripData['Status'] == 'active') {
            Trip trip = Trip.fromMap(tripData);
            activeTrips.add(trip);

            print("Fetched Trip ID: ${trip.id}");
            print("From: ${trip.FromLocation} → To: ${trip.ToDestination}");
            print("Status: ${trip.Status}, Price: ${trip.price}");
          }
        }
      }

      return activeTrips;
    });
  }


}

