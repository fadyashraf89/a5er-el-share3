import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import '../../../../../core/utils/constants.dart';
import '../../../../Driver/domain/models/driver.dart';
import '../../../data/Database/FirebaseTripStorage.dart';
import '../../../domain/models/trip.dart';

part 'trip_state.dart';

class TripCubit extends Cubit<TripState> {
  final FirebaseTripStorage tripStorage;

  TripCubit({required this.tripStorage}) : super(TripInitial());

  Future<void> addTrips(List<Trip> trips,
      {Duration expiryDuration = const Duration(minutes: 3)}) async {
    emit(TripLoading());
    try {
      await tripStorage.addTrip(trips);
      emit(TripRequestSuccess("Trips successfully added."));
      for (var trip in trips) {
        emit(TripActive(trip));
        setTripStatus(trip, expiryDuration);
        emit(TripRequested(trip, expiryDuration));
      }
    } catch (e) {
      emit(TripError("Failed to add trips: $e"));
    }
  }

  void setTripStatus(Trip trip, Duration expiryDuration) async {
    final batch = FirebaseFirestore.instance.batch();
    final CollectionReference tripsCollection =
    FirebaseFirestore.instance.collection(kTripsCollection);
    final activeTripsCollection =
    FirebaseFirestore.instance.collection(kActiveTripsCollection),
        expiredTripsCollection =
        FirebaseFirestore.instance.collection(kExpiredTripsCollection);

    emit(TripLoading());

    try {
      if (trip.driver == null) throw Exception("Driver not found.");
      emit(TripAccepted(trip));

      String? documentId = trip.passenger?.email;
      if (documentId == null || documentId.isEmpty) {
        throw Exception("Invalid passenger email, cannot update trip status.");
      }

      batch.update(
          tripsCollection.doc(documentId),
          {'trips': FieldValue.arrayRemove([trip.toMap()])});

      batch.update(
          activeTripsCollection.doc(documentId),
          {'trips': FieldValue.arrayUnion([trip.toMap()])});

      await batch.commit();

      Timer(expiryDuration, () async {
        if (trip.Status == "Active") {
          trip = trip.copyWith(Status: "Expired");
          batch.update(
              activeTripsCollection.doc(documentId),
              {'trips': FieldValue.arrayRemove([trip.toMap()])});

          batch.set(
              expiredTripsCollection.doc(documentId),
              {'trips': FieldValue.arrayUnion([trip.toMap()])},
              SetOptions(merge: true));

          await batch.commit();

          emit(TripInitial());
        }
      });
    } catch (e) {
      emit(TripError("Error updating trip status: $e"));
    }
  }

  Future<void> fetchTripsForLoggedInUser() async {
    emit(TripLoading());
    try {
      final trips = await tripStorage.fetchTripsForLoggedInUser();
      emit(TripDataFetched(trips));
    } catch (e) {
      print('Error fetching trips: $e');
      emit(TripError("Failed to fetch trips: $e"));
    }
  }

  Future<void> fetchTripsForUser(String userEmail) async {
    emit(TripLoading());
    try {
      final trips = await tripStorage.fetchTripsForUser(userEmail);
      emit(TripDataFetched(trips));
    } catch (e) {
      print('Error fetching trips for user: $userEmail $e');
      emit(TripError("Failed to fetch trips for user $userEmail: $e"));
    }
  }

  Future<void> fetchAcceptedTripsForUser(String userEmail) async {
    emit(TripLoading());
    try {
      final trips = await tripStorage.fetchAcceptedTripsForUser(userEmail);
      emit(TripDataFetched(trips));
    } catch (e) {
      print('Error fetching accepted trips for user: $userEmail $e');
      emit(TripError("Failed to fetch accepted trips for user $userEmail: $e"));
    }
  }

  Future<void> fetchRejectedTripsForUser(String userEmail) async {
    emit(TripLoading());
    try {
      final trips = await tripStorage.fetchRejectedTripsForUser(userEmail);
      emit(TripDataFetched(trips));
    } catch (e) {
      print('Error fetching rejected trips for user: $userEmail $e');
      emit(TripError("Failed to fetch rejected trips for user $userEmail: $e"));
    }
  }

  Future<void> fetchAllTrips(String userEmail) async {
    emit(TripLoading());
    try {
      final trips = await tripStorage.fetchTripsForUser(userEmail);
      await tripStorage.fetchAcceptedTripsForUser(userEmail);
      final allTrips = [
        ...trips.reversed,
      ];
      emit(TripDataFetched(allTrips));
    } catch (e) {
      print('Error fetching all trips: $e');
      emit(TripError("Failed to fetch trips: $e"));
    }
  }

  void calculateTripDetails(
      LatLng pickupLocation, LatLng destinationLocation) async {
    try {
      double distanceInKilometers =
      calculateDistance(pickupLocation, destinationLocation);
      double price = calculatePrice(distanceInKilometers);
      emit(TripRequestSuccess(
          "Trips successfully added. Distance: ${distanceInKilometers.toStringAsFixed(2)} km, Price: \$${price.toStringAsFixed(2)}"));
    } catch (e) {
      emit(TripRequestFailed(
          "Failed to calculate distance or price. Error: ${e.toString()}"));
    }
  }

  double calculateDistance(LatLng point1, LatLng point2) {
    double distanceInMeters = Geolocator.distanceBetween(
      point1.latitude,
      point1.longitude,
      point2.latitude,
      point2.longitude,
    );
    double distanceInKilometers = distanceInMeters / 1000;
    return distanceInKilometers;
  }

  double calculatePrice(double distanceInKilometers) {
    double price = distanceInKilometers * 3;
    return price;
  }

  Future<void> acceptTrip(
      String userEmail, Map<String, dynamic> tripData, Driver driver) async {
    try {
      emit(TripLoading());

      // Reference to the user's document in the ActiveTrips collection
      DocumentReference userActiveTripsDoc =
      FirebaseFirestore.instance.collection('Active Trips').doc(userEmail);

      DocumentSnapshot userDocSnapshot = await userActiveTripsDoc.get();
      if (!userDocSnapshot.exists) {
        throw Exception("User document not found in ActiveTrips collection");
      }

      List<dynamic> activeTripsList = List.from(userDocSnapshot['trips'] ?? []);

      final tripIndex = activeTripsList.indexWhere(
              (trip) => trip['Distance'] == tripData['Distance']);
      if (tripIndex == -1) {
        throw Exception("Trip not found in the ActiveTrips collection");
      }

      Map<String, dynamic> selectedTrip = activeTripsList[tripIndex];
      activeTripsList.removeAt(tripIndex);



      await userActiveTripsDoc.update({'trips': activeTripsList});

      selectedTrip['Status'] = "accepted";
      selectedTrip['driver'] = driver.toMap();

      final updatedTrip = Trip.fromMap(selectedTrip);
      emit(TripAccepted(updatedTrip));

      await FirebaseFirestore.instance.collection('AcceptedTrips').add(selectedTrip);

      print("Trip successfully accepted and moved to AcceptedTrips.");
    } catch (e) {
      print("Error accepting trip: $e");
      emit(TripError("Failed to accept trip: $e"));
    }
  }

  void StartTrip(Trip trip) {
    try {
      emit(TripStarted(trip));
    } catch (e) {
      print("Error starting the trip: $e");
    }
  }

  void EndTrip(Trip trip) async {
    try {
      emit(TripFinished(trip));
      await Future.delayed(const Duration(seconds: 300));
      emit(TripInitial());
    } catch (e) {
      print("Error finishing the trip: $e");
    }
  }
}
