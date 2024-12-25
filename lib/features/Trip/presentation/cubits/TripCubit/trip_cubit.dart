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

  Future<void> fetchTripsForUser(String userEmail) async {
    emit(TripLoading());
    try {
      final trips = await tripStorage.fetchTripsForUser(userEmail);
      emit(TripDataFetched(trips));
    } catch (e) {
      emit(TripError("Failed to fetch trips for user $userEmail: $e"));
    }
  }

// Integrated function to calculate distance and price
  void calculateTripDetails(LatLng pickupLocation, LatLng destinationLocation) async {
    try {
      // Calculate the distance first
      double distanceInKilometers = calculateDistance(pickupLocation, destinationLocation);

      // Calculate the price based on the distance
      double price = calculatePrice(distanceInKilometers);

      // Emit the result with the distance and price
      emit(TripRequestSuccess(
          "Trips successfully added. Distance: ${distanceInKilometers.toStringAsFixed(2)} km, Price: \$${price.toStringAsFixed(2)}"
      ));
    } catch (e) {
      // Handle any errors that might occur during calculation
      emit(TripRequestFailed("Failed to calculate distance or price. Error: ${e.toString()}"));
    }
  }

// Function to calculate the distance between two points (in kilometers)
  double calculateDistance(LatLng point1, LatLng point2) {
    double distanceInMeters = Geolocator.distanceBetween(
      point1.latitude,
      point1.longitude,
      point2.latitude,
      point2.longitude,
    );

    double distanceInKilometers = distanceInMeters / 1000; // Convert meters to kilometers
    return distanceInKilometers;
  }

// Function to calculate the price based on the distance (example: $3 per kilometer)
  double calculatePrice(double distanceInKilometers) {
    double price = distanceInKilometers * 3; // Pricing formula ($3 per kilometer)
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
