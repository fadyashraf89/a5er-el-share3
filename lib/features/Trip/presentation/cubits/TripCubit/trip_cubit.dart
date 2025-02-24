import 'dart:async';

import 'package:a5er_elshare3/core/utils/Injections/dependency_injection.dart';
import 'package:a5er_elshare3/features/Trip/domain/UseCases/addTripUseCase.dart';
import 'package:a5er_elshare3/features/Trip/domain/UseCases/fetchTripsForLoggedInUserUseCase.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import '../../../../Driver/domain/models/driver.dart';
import '../../../../Passenger/domain/UseCases/FetchPassengerDataUseCase.dart';
import '../../../../Passenger/domain/models/Passenger.dart';
import '../../../domain/Repositories/TripRepository.dart';
import '../../../domain/UseCases/fetchTripsForUserUseCase.dart';
import '../../../domain/models/trip.dart';

part 'trip_state.dart';

class TripCubit extends Cubit<TripState> {
  TripCubit() : super(TripInitial());

  Future<void> addTrips(List<Trip> trips, {Duration expiryDuration = const Duration(seconds: 120)}) async {
    emit(TripLoading());

    try {
      final passenger = await _fetchPassenger();
      if (passenger == null || passenger.email == null) {
        emit(TripError("Passenger data not found or email is missing."));
        return;
      }

      final updatedTrips = trips.map((trip) => trip.copyWith(passenger: passenger, Status: "active")).toList();
      await sl<addTripUseCase>().addTrip(updatedTrips);

      emit(TripRequestSuccess("Trips successfully added."));

      for (var trip in updatedTrips) {
        emit(TripActive(trip, expiryDuration, passenger: passenger));
        _scheduleTripExpiry(trip.id!, expiryDuration, passenger.email!);
      }
    } catch (e) {
      emit(TripError("Failed to add trips: ${e.toString()}"));
    }
  }

  Future<Passenger?> _fetchPassenger() async {
    try {
      return await sl<FetchPassengerDataUseCase>().fetchPassengerData();
    } catch (e) {
      return null;
    }
  }

  void _scheduleTripExpiry(String tripId, Duration expiryDuration, String email) {
    Timer(expiryDuration, () async {
      await _expireTrip(tripId, email);
    });
  }

  Future<void> _expireTrip(String tripId, String email) async {
    try {
      await sl<TripRepository>().expireTrip(tripId, email);
      final trip = await _fetchTripById(tripId);
      emit(TripExpired(trip));
      emit(TripInitial());
    } catch (e) {
      emit(TripError("Failed to expire trip: ${e.toString()}"));
    }
  }

  // Future<List<dynamic>> _removeTripFromActiveTrips(String userEmail, String? tripId) async {
  //   try {
  //     final snapshot = await FirebaseFirestore.instance.collection(kActiveTripsCollection).doc(userEmail).get();
  //     if (!snapshot.exists) return [];
  //
  //     final data = snapshot.data();
  //     final activeTrips = data?['trips'] ?? [];
  //
  //     return activeTrips.where((t) => t['id'] != tripId).toList();
  //   } catch (e) {
  //     emit(TripError("Error removing trip: ${e.toString()}"));
  //     return [];
  //   }
  // }

  Future<void> fetchTripsForLoggedInUser() async {
    emit(TripLoading());
    try {
      final trips = await sl<fetchTripsForLoggedInUserUseCase>().fetchTripsForLoggedInUser();
      emit(TripDataFetched(trips));
    } catch (e) {
      emit(TripError("Failed to fetch trips: ${e.toString()}"));
    }
  }

  Future<void> fetchTripsForUser(String userEmail) async {
    emit(TripLoading());
    try {
      final trips = await sl<fetchTripsForUserUseCase>().fetchTripsForUser(userEmail);
      emit(trips.isEmpty ? TripError("No trips found for user $userEmail.") : TripDataFetched(trips));
    } catch (e) {
      emit(TripError("Failed to fetch trips for user $userEmail: ${e.toString()}"));
    }
  }


  // Future<void> fetchAcceptedTripsForUser(String userEmail) async {
  //   emit(TripLoading());
  //   try {
  //     fetchAcceptedTripsForUserUseCase accepted =
  //         sl<fetchAcceptedTripsForUserUseCase>();
  //     final trips = await accepted.fetchAcceptedTripsForUser(userEmail);
  //     emit(TripDataFetched(trips));
  //   } catch (e) {
  //     print('Error fetching accepted trips for user: $userEmail $e');
  //     emit(TripError("Failed to fetch accepted trips for user $userEmail: $e"));
  //   }
  // }

  Future<void> fetchAllTrips(String userEmail) async {
    emit(TripLoading());
    try {
      fetchTripsForUserUseCase tripsforuser = sl<fetchTripsForUserUseCase>();
      // fetchAcceptedTripsForUserUseCase accepted =
      //     sl<fetchAcceptedTripsForUserUseCase>();

      final trips = await tripsforuser.fetchTripsForUser(userEmail);
      // await accepted.fetchAcceptedTripsForUser(userEmail);
      final allTrips = [
        ...trips.reversed,
      ];
      emit(TripDataFetched(allTrips));
    } catch (e) {
      print('Error fetching all trips: $e');
      emit(TripError("Failed to fetch trips: $e"));
    }
  }

  // Future<void> acceptTrip(String tripId, String? email, Driver driver) async {
  //   emit(TripLoading()); // 🟡 Set Loading State
  //   try {
  //     if (email == null) throw Exception("User email is required.");
  //
  //     // ✅ Ensure the transaction completes before proceeding
  //     await sl<TripRepository>().acceptTrip(tripId, email, driver);
  //
  //     // ✅ Short delay to ensure Firestore updates are reflected
  //     await Future.delayed(const Duration(milliseconds: 500));
  //
  //     // ✅ Fetch updated trip details
  //     final trip = await _fetchTripById(tripId);
  //     emit(TripAccepted(trip)); // ✅ Emit success state
  //
  //   } catch (e) {
  //     emit(TripError("Failed to accept trip: ${e.toString()}"));
  //   }
  // }


  Future<void> acceptTrip(String tripId, Driver driver) async {
    try {
      emit(TripLoading());

      // ✅ Step 1: Query Active Trips Collection to Find the Trip
      QuerySnapshot activeTripsQuery = await FirebaseFirestore.instance.collection("Active Trips").get();

      DocumentReference? targetDocRef;
      List<dynamic> updatedTripsList = [];

      for (var doc in activeTripsQuery.docs) {
        List<dynamic> trips = List.from(doc["trips"] ?? []);

        // ✅ Step 2: Find the trip inside the document
        final tripIndex = trips.indexWhere((trip) => trip["id"] == tripId);
        if (tripIndex != -1) {
          Map<String, dynamic> selectedTrip = trips[tripIndex];

          // ✅ Step 3: Remove from Active Trips
          trips.removeAt(tripIndex);
          targetDocRef = doc.reference;
          updatedTripsList = trips;

          // ✅ Step 4: Update trip status and assign driver
          selectedTrip["Status"] = "accepted";
          selectedTrip["driver"] = driver.toMap();

          // ✅ Step 5: Move to Accepted Trips collection
          await FirebaseFirestore.instance.collection('AcceptedTrips').add(selectedTrip);

          // ✅ Step 6: Emit updated trip
          final updatedTrip = Trip.fromMap(selectedTrip);
          emit(TripAccepted(updatedTrip));

          print("✅ Trip successfully accepted and moved to AcceptedTrips.");
          break;
        }
      }

      // ✅ Step 7: Update the original Active Trips document (if the trip was found)
      if (targetDocRef != null) {
        await targetDocRef.update({
          'trips': updatedTripsList.isEmpty ? FieldValue.delete() : updatedTripsList,
        });
      } else {
        throw Exception("Trip not found in Active Trips collection.");
      }
    } catch (e) {
      print("❌ Error accepting trip: $e");
      emit(TripError("Failed to accept trip: $e"));
    }
  }
  Future<Trip> _fetchTripById(String tripId) async {
    try {
      return await sl<TripRepository>().fetchTripById(tripId);
    } catch (e) {
      throw Exception("Failed to fetch trip: ${e.toString()}");
    }
  }

  void calculateTripDetails(LatLng pickupLocation, LatLng destinationLocation) async {
    try {
      double distanceInKilometers = calculateDistance(pickupLocation, destinationLocation);
      double price = calculatePrice(distanceInKilometers);
      emit(TripRequestSuccess(
          "Trips successfully added. Distance: ${distanceInKilometers.toStringAsFixed(2)} km, Price: \$${price.toStringAsFixed(2)}"));
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
    return distanceInMeters / 1000; // Convert to kilometers
  }

  double calculatePrice(double distanceInKilometers) {
    return distanceInKilometers * 3; // Example pricing logic
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

      // ✅ Ensure the trip has points to process
      int tripPoints = trip.points ?? 0;

      // ✅ Validate passenger UID
      String? passengerUid = trip.passenger?.uid;
      if (passengerUid == null || passengerUid.isEmpty) {
        throw Exception("Invalid passenger UID, cannot update points.");
      }

      final firestore = FirebaseFirestore.instance;
      final passengerDocRef = firestore.collection('Passengers').doc(passengerUid);

      // ✅ Firestore Transaction for Atomic Payment Update
      await firestore.runTransaction((transaction) async {
        // Fetch passenger document
        DocumentSnapshot passengerSnapshot = await transaction.get(passengerDocRef);
        if (!passengerSnapshot.exists) {
          throw Exception("Passenger document not found.");
        }

        // ✅ Extract passenger data
        Map<String, dynamic> passengerData = passengerSnapshot.data() as Map<String, dynamic>;
        int currentPoints = passengerData['points'] ?? 0;
        String paymentMethod = trip.paymentMethod ?? '';

        if (paymentMethod == 'Points') {
          // ✅ Deduct trip points if the passenger paid using points
          if (currentPoints < tripPoints) {
            throw Exception("Not enough points to complete the trip payment.");
          }
          transaction.update(passengerDocRef, {'points': FieldValue.increment(-tripPoints)});
          print("✅ Deducted $tripPoints points from passenger. ${trip.passenger!.name}");
        } else {
          // ✅ Reward points if another payment method was used
          transaction.update(passengerDocRef, {'points': FieldValue.increment(tripPoints)});
          print("✅ Rewarded $tripPoints points to passenger.${trip.passenger!.name}");
        }
      });

      // ✅ Delay to show TripFinished state before resetting
      await Future.delayed(const Duration(seconds: 10));
      emit(TripInitial());

      print("✅ Trip successfully completed.");
    } catch (e) {
      print("❌ Error finishing the trip: $e");
      emit(TripError("Error finishing the trip: $e"));
    }
  }

  Future<void> DismissTrip(Trip trip, Driver driver) async {
    try {
      emit(TripDismissed(trip, driver));
      await Future.delayed(const Duration(seconds: 10));
      emit(TripInitial());
    } catch (e) {
      print("Error dismissing the trip: $e");
    }
  }
}
