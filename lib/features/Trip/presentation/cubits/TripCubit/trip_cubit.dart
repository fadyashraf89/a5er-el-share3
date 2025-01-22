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

  Future<void> addTrips(List<Trip> trips, {Duration expiryDuration = const Duration(minutes: 1)}) async {
    emit(TripLoading());
    try {
      await tripStorage.addTrip(trips);
      emit(TripRequestSuccess("Trips successfully added."));

      for (var trip in trips) {
        emit(TripActive(trip));
        emit(TripRequested(trip, expiryDuration));
        // Set a timer to handle trip expiry
        setTripStatus(trip, expiryDuration);
      }

    } catch (e) {
      emit(TripError("Failed to add trips: $e"));
    }
  }


  void setTripStatus(Trip trip, Duration expiryDuration) async {
    final CollectionReference tripsCollection =
    FirebaseFirestore.instance.collection(kTripsCollection);

    emit(TripLoading());

    try {
      // Immediately set the trip as "Active" when it is requested successfully
      trip = trip.copyWith(Status: "Active");
      emit(TripAccepted(trip));

      // Update the trip status in Firebase
      String? documentId = trip.passenger?.email;
      if (documentId == null || documentId.isEmpty) {
        throw Exception("Invalid passenger email, cannot update trip status in Firebase.");
      }

      // Find the correct trip in Firebase by its ID and update the status
      await tripsCollection.doc(documentId).update({
        'trips': FieldValue.arrayRemove([trip.toMap()]), // Remove the old trip
      });

      await tripsCollection.doc(documentId).update({
        'trips': FieldValue.arrayUnion([trip.toMap()]), // Add the updated trip
      });

      // Set a timer to change status to "Expired"
      Timer(expiryDuration, () async {
        if (trip.Status == "Active") {
          trip = trip.copyWith(Status: "Expired");
          emit(TripExpired(trip));

          // Update Firebase to reflect the status change to "Expired"
          await tripsCollection.doc(documentId).update({
            'trips': FieldValue.arrayRemove([trip.toMap()]), // Remove old status
          });

          await tripsCollection.doc(documentId).update({
            'trips': FieldValue.arrayUnion([trip.toMap()]), // Add updated status
          });
        }
      });
    } catch (e) {
      print("Error updating trip status: $e");
      emit(TripError(e.toString()));
    }
  }



  Future<void> fetchTripsForLoggedInUser() async {
    emit(TripLoading());
    try {
      final trips = await tripStorage.fetchTripsForLoggedInUser();
      emit(TripDataFetched(trips));
    } catch (e) {
      emit(TripError("Failed to fetch trips: $e"));
    }
  }
    Future<void> fetchTripsForUser(String userEmail) async {
    emit(TripLoading());
    try {
      final trips = await tripStorage.fetchTripsForUser(userEmail);
      emit(TripDataFetched(trips));
    } catch (e) {
      emit(TripError("Failed to fetch trips for user $userEmail: $e"));
    }
  }
  Future<void> fetchAcceptedTripsForUser(String userEmail) async {
    emit(TripLoading());
    try {
      final trips = await tripStorage.fetchAcceptedTripsForUser(userEmail);
      emit(TripDataFetched(trips));
    } catch (e) {
      emit(TripError("Failed to fetch accepted trips for user $userEmail: $e"));
    }
  }
  Future<void> fetchRejectedTripsForUser(String userEmail) async {
    emit(TripLoading());
    try {
      final trips = await tripStorage.fetchRejectedTripsForUser(userEmail);
      emit(TripDataFetched(trips));
    } catch (e) {
      emit(TripError("Failed to fetch rejected trips for user $userEmail: $e"));
    }
  }

  Future<void> fetchAllTrips(String userEmail) async {
    emit(TripLoading());
    try {
      final trips = await tripStorage.fetchTripsForUser(userEmail);
      final acceptedTrips = await tripStorage.fetchAcceptedTripsForUser(userEmail);
      final rejectedTrips = await tripStorage.fetchRejectedTripsForUser(userEmail);

      final allTrips = [...trips.reversed, ...acceptedTrips.reversed, ...rejectedTrips.reversed];
      emit(TripDataFetched(allTrips));
    } catch (e) {
      emit(TripError("Failed to fetch trips: $e"));
    }
  }

  void calculateTripDetails(LatLng pickupLocation, LatLng destinationLocation) async {
    try {
      double distanceInKilometers = calculateDistance(pickupLocation, destinationLocation);
      double price = calculatePrice(distanceInKilometers);
      emit(TripRequestSuccess(
          "Trips successfully added. Distance: ${distanceInKilometers.toStringAsFixed(2)} km, Price: \$${price.toStringAsFixed(2)}"
      ));
    } catch (e) {
      emit(TripRequestFailed("Failed to calculate distance or price. Error: ${e.toString()}"));
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

  Future<void> fetchAllRequestedTrips() async {
    emit(TripLoading());
    try {
      final requestedTrips = await tripStorage.fetchAllRequestedTrips();
      emit(TripDataFetched(requestedTrips));
    } catch (e) {
      emit(TripError("Failed to fetch requested trips: $e"));
    }
  }

  Future<void> acceptTrip(String userEmail, Map<String, dynamic> tripData, Driver driver) async {
    emit(TripLoading());
    try {
      await tripStorage.acceptTrip(userEmail, tripData, driver);
      emit(TripAccepted(Trip.fromMap(tripData)));
    } catch (e) {
      emit(TripError("Failed to accept trip: $e"));
    }
  }

  Future<void> rejectTrip(String userEmail, Map<String, dynamic> tripData, Driver driver) async {
    emit(TripLoading());
    try {
      await tripStorage.RejectTrip(userEmail, tripData, driver);
      emit(TripRejected(message: "Trip rejected successfully.", trip: Trip.fromMap(tripData)));
    } catch (e) {
      emit(TripError("Failed to reject trip: $e"));
    }
  }
}
