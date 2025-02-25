import '../../../Driver/domain/models/driver.dart';
import '../models/trip.dart';

abstract class TripRepository{
  Future<void> addTrip(List<Trip> tripsList);
  Future<List<Trip>> fetchTripsForUser(String userEmail);
  Future<void> acceptTrip(String tripId, String userEmail, Driver driver);
  Stream<List<Trip>> getActiveTripsStream();
  Future<void> expireTrip(String tripId, String userEmail);
  Future<Trip> fetchTripById(String tripId);
}