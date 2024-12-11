import 'package:bloc/bloc.dart';
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
