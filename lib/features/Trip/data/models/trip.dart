import '../../../Driver/data/models/driver.dart';
import '../../../Passenger/data/models/Passenger.dart';

class Trip {
  final String? date, time, FromLocation, ToDestination;
  final Driver? driver;
  final Passenger? passenger;

  Trip(
      {required this.date,
      required this.time,
      required this.FromLocation,
      required this.ToDestination,
      required this.driver,
      required this.passenger});
}
