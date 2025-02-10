import 'package:firebase_auth/firebase_auth.dart';
import '../../../Driver/domain/models/driver.dart';
import '../../domain/models/trip.dart';

final User? currentUser = FirebaseAuth.instance.currentUser;
final String? currentEmail = currentUser?.email;

abstract class TripStorage {
  Future<void> addTrip(List<Trip> tripsList);
  Future<List<Trip>> fetchTripsForLoggedInUser();
  Future<List<Trip>> fetchAcceptedTripsForUser(String userMail);
  Future<List<Trip>> fetchRejectedTripsForUser(String userMail);
  Future<List<Trip>> fetchTripsForUser(String userEmail);
  Future<void> acceptTrip(String userEmail, Map<String, dynamic> tripData, Driver driver);
  Stream<List<Trip>> getRequestedTripsStream();
}