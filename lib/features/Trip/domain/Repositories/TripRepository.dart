import '../../../Driver/domain/models/driver.dart';
import '../models/trip.dart';

abstract class TripRepository{
  Future<void> addTrip(List<Trip> tripsList);
  Future<List<Trip>> fetchTripsForLoggedInUser();
  Future<List<Trip>> fetchAcceptedTripsForUser(String userMail);
  Future<List<Trip>> fetchRejectedTripsForUser(String userMail);
  Future<List<Trip>> fetchTripsForUser(String userEmail);
  Future<void> acceptTrip(String userEmail, Map<String, dynamic> tripData, Driver driver);
  Stream<List<Trip>> getRequestedTripsStream();
  Stream<List<Trip>> getActiveTripsStream();

}