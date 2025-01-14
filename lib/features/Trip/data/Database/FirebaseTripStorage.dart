import 'package:a5er_elshare3/core/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../AuthService/data/Database/FirebaseAuthentication.dart';
import '../../../Driver/domain/models/driver.dart';
import '../../domain/models/trip.dart';
import 'TripStorage.dart';

final User? currentUser = FirebaseAuth.instance.currentUser;
final String? currentEmail = currentUser?.email;

class FirebaseTripStorage extends TripStorage {
  @override
  Future<void> addTrip(List<Trip> tripsList) async {
    CollectionReference tripsCollection =
        FirebaseFirestore.instance.collection(kTripsCollection);
    CollectionReference historyCollection =
        FirebaseFirestore.instance.collection(kTripHistoryCollection);

    for (Trip trip in tripsList) {
      String documentId = trip.passenger?.email ?? '';

      await tripsCollection.doc(documentId).set({
        'trips': FieldValue.arrayUnion([]),
      }, SetOptions(merge: true));

      await tripsCollection.doc(documentId).update({
        'trips': FieldValue.arrayUnion(
          tripsList.map((trip) => trip.toMap()).toList(),
        ),
      });

      Map<String, dynamic> tripMap = trip.toMap();

      await historyCollection.doc(documentId).set({
        'trips': FieldValue.arrayUnion([]),
      }, SetOptions(merge: true));

      await historyCollection.doc(documentId).update({
        'trips': FieldValue.arrayUnion([tripMap]),
      });
    }
  }

  @override
  Future<List<Trip>> fetchTripsForLoggedInUser() async {
    AuthService auth = AuthService();
    try {
      String? currentEmail = await auth.getCurrentUserEmail();

      if (currentEmail == null) {
        print("No user currently signed in.");
        return [];
      }

      return await fetchTripsForUser(currentEmail);
    } catch (e) {
      print("Error fetching trips for logged-in user: $e");
      return [];
    }
  }

  @override
  Future<List<Trip>> fetchTripsForUser(String userEmail) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection(kTripsCollection)
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

  @override
  Future<List<Trip>> fetchAcceptedTripsForUser(String userMail) async {
    try {
      CollectionReference acceptedTripsCollection =
          FirebaseFirestore.instance.collection(kAcceptedTripsCollection);

      QuerySnapshot querySnapshot = await acceptedTripsCollection
          .where('passenger.email', isEqualTo: userMail)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print("No accepted trips found for user $userMail.");
        return [];
      }

      List<Trip> acceptedTrips = querySnapshot.docs.map((doc) {
        return Trip.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      return acceptedTrips;
    } catch (e) {
      print("Error fetching accepted trips for user $userMail: $e");
      return [];
    }
  }

  @override
  Future<List<Trip>> fetchRejectedTripsForUser(String userMail) async {
    try {
      CollectionReference RejectedTripsCollection =
          FirebaseFirestore.instance.collection(kRejectedTripsCollection);

      QuerySnapshot querySnapshot = await RejectedTripsCollection.where(
              'passenger.email',
              isEqualTo: userMail)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print("No rejected trips found for user $userMail.");
        return [];
      }

      List<Trip> rejectedTrips = querySnapshot.docs
          .map((doc) => Trip.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      return rejectedTrips;
    } catch (e) {
      print("Error fetching rejected trips for user $userMail: $e");
      return [];
    }
  }

  @override
  Future<List<Trip>> fetchAllRequestedTrips() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection(kTripsCollection).get();

      List<Trip> requestedTrips = [];

      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final List<dynamic> tripDataList = data['trips'] ?? [];

        for (var tripData in tripDataList) {
          if (tripData['Status'] == 'Requested') {
            requestedTrips.add(Trip.fromMap(tripData as Map<dynamic, dynamic>));
          }
        }
      }

      return requestedTrips;
    } catch (e) {
      print("Error fetching requested trips: $e");
      return [];
    }
  }

  @override
  Future<void> acceptTrip(
      String userEmail, Map<String, dynamic> tripData, Driver driver) async {
    try {
      DocumentReference userTripsDoc =
          FirebaseFirestore.instance.collection(kTripsCollection).doc(userEmail);

      if (tripData['passenger'] == null) {
        throw Exception("Missing passenger data in trip.");
      }

      String passengerUid = tripData['passenger']['uid'] ?? '';
      if (passengerUid.isEmpty) {
        throw Exception("Invalid or missing passenger UID.");
      }

      DocumentReference passengerDoc =
          FirebaseFirestore.instance.collection('Passengers').doc(passengerUid);
      if (!(await passengerDoc.get()).exists) {
        throw Exception("Passenger document not found.");
      }

      DocumentSnapshot userDocSnapshot = await userTripsDoc.get();
      if (!userDocSnapshot.exists) throw Exception("User document not found.");

      List<dynamic> tripsList = userDocSnapshot['trips'];
      final tripIndex = tripsList
          .indexWhere((trip) => trip['Distance'] == tripData['Distance']);
      if (tripIndex == -1) throw Exception("Trip not found.");

      Map<String, dynamic> selectedTrip = tripsList[tripIndex];
      tripsList.removeAt(tripIndex);
      await userTripsDoc.update({'trips': tripsList});

      selectedTrip['Status'] = "accepted";
      selectedTrip['driver'] = driver.toMap();

      await FirebaseFirestore.instance
          .collection(kAcceptedTripsCollection)
          .add(selectedTrip);

      int tripPoints = tripData['points'] ?? 0;
      String paymentMethod = tripData['paymentMethod'] ?? '';

      if (paymentMethod == 'Points') {
        DocumentSnapshot passengerSnapshot = await passengerDoc.get();
        int currentPoints = passengerSnapshot['points'] ?? 0;

        if (currentPoints >= tripPoints) {
          await passengerDoc
              .update({'points': FieldValue.increment(-tripPoints)});
          print("Decremented points by $tripPoints.");
        } else {
          throw Exception("Not enough points to complete the payment.");
        }
      } else {
        await passengerDoc.update({'points': FieldValue.increment(tripPoints)});
        print("Incremented points by $tripPoints.");
      }
      print("Trip accepted and moved to $kAcceptedTripsCollection");

      DocumentReference historyDoc =
          FirebaseFirestore.instance.collection(kTripHistoryCollection).doc(userEmail);

      await historyDoc.set(
        {
          'trips': FieldValue.arrayUnion([selectedTrip]),
        },
        SetOptions(merge: true),
      );
      print("Trip accepted and added to $kTripHistoryCollection collection.");
    } catch (e) {
      print("Error: ${e.toString()}, Stack: ${StackTrace.current}");
      throw Exception("Failed to accept trip.");
    }
  }

  @override
  Future<void> RejectTrip(String userEmail, Map<String, dynamic> tripData, Driver driver) async {
    try {
      DocumentReference userTripsDoc =
          FirebaseFirestore.instance.collection(kTripsCollection).doc(userEmail);

      CollectionReference rejectedTrips = FirebaseFirestore.instance.collection(kRejectedTripsCollection);
      DocumentSnapshot userDocSnapshot = await userTripsDoc.get();

      if (!userDocSnapshot.exists) {
        throw Exception("User document not found");
      }

      List<dynamic> tripsList = userDocSnapshot['trips'];

      final tripIndex = tripsList
          .indexWhere((trip) => trip['Distance'] == tripData['Distance']);
      if (tripIndex == -1) {
        throw Exception("Trip not found");
      }

      Map<String, dynamic> selectedTrip = tripsList[tripIndex];
      tripsList.removeAt(tripIndex);

      await userTripsDoc.update({'trips': tripsList});

      selectedTrip['Status'] = "rejected";
      tripsList[tripIndex]['Status'] = "rejected";

      selectedTrip['driver'] = driver.toMap();

      DocumentReference historyDoc =
          FirebaseFirestore.instance.collection(kTripHistoryCollection).doc(userEmail);

      await historyDoc.set(
        {
          'trips': FieldValue.arrayUnion([selectedTrip]),
        },
        SetOptions(merge: true),
      );

      rejectedTrips.add(selectedTrip);

      print("Trip rejected and added to $kTripHistoryCollection collection and $kRejectedTripsCollection.");
    } catch (e) {
      print("Error rejecting trip: $e");
      throw Exception("Failed to reject trip: $e");
    }
  }

  @override
  Stream<List<Trip>> getRequestedTripsStream() => FirebaseFirestore.instance
          .collection(kTripsCollection)
          .snapshots()
          .map((snapshot) {
        List<Trip> requestedTrips = [];
        for (var doc in snapshot.docs) {
          final data = doc.data();
          final List<dynamic> tripDataList = data['trips'] ?? [];

          for (var tripData in tripDataList) {
            if (tripData['Status'] == 'Requested') {
              requestedTrips
                  .add(Trip.fromMap(tripData as Map<String, dynamic>));
            }
          }
        }
        return requestedTrips;
      });
}
