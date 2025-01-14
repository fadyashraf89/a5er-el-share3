import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import '../../../../Driver/domain/models/driver.dart';
import '../../../data/Database/FirebaseTripStorage.dart';
import '../../../domain/models/trip.dart';

part 'trip_state.dart';

class TripCubit extends Cubit<TripState> {
  final FirebaseTripStorage tripStorage;

  TripCubit({required this.tripStorage}) : super(TripInitial());

  Future<void> addTrips(List<Trip> trips) async {
    emit(TripLoading());
    try {
      await tripStorage.addTrip(trips);
      emit(TripRequestSuccess("Trips successfully added."));
    } catch (e) {
      emit(TripError("Failed to add trips: $e"));
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

  // Future<void> fetchTripHistoryForUser(String userEmail) async {
  //   emit(TripLoading());
  //   try {
  //     final history = await tripStorage.fetchTripHistoryForUser(userEmail);
  //     emit(TripHistoryFetched(history));
  //   } catch (e) {
  //     emit(TripError("Failed to fetch trip history for user $userEmail: $e"));
  //   }
  // }

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
// Combine both trips if needed
  Future<void> fetchAllTrips(String userEmail) async {
    emit(TripLoading());
    try {
      // Fetch trips and accepted trips
      final trips = await tripStorage.fetchTripsForUser(userEmail);
      final acceptedTrips = await tripStorage.fetchAcceptedTripsForUser(userEmail);
      final rejectedTrips = await tripStorage.fetchRejectedTripsForUser(userEmail);

      // Combine both lists into one
      final allTrips = [...trips, ...acceptedTrips, ...rejectedTrips];
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
