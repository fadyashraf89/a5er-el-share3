import '../../../Driver/data/models/driver.dart';
import '../../../Passenger/data/models/Passenger.dart';

class Trip {
  final String? date, time, FromLocation, ToDestination;
  final Driver? driver;
  final Passenger? passenger;
  final double? distance;
  final String? Status;

  Trip(
      {required this.date,
      required this.distance,
      required this.Status,
      required this.time,
      required this.FromLocation,
      required this.ToDestination,
      required this.driver,
      required this.passenger});
  factory Trip.fromMap(Map<String, dynamic> data) {
    return Trip(
      distance: data['Distance'] as double?,
      FromLocation: data['FromLocation'] as String?,
      ToDestination: data['ToDestination'] as String?,
      Status: data['Status'] as String?,
      date: data['date'] as String?,
      time: data['time'] as String?,
      driver: data['driver'] != null
          ? Driver.fromMap(data['driver'] as Map<String, dynamic>)
          : null,
      passenger: data['passenger'] != null
          ? Passenger.fromMap(data['passenger'] as Map<String, dynamic>)
          : null,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'time': time,
      'FromLocation': FromLocation,
      'ToDestination': ToDestination,
      'Status': Status,
      'Distance': distance,
      'driver': driver?.toMap(), // Convert driver to a Map if not null
      'passenger': passenger?.toMap(), // Convert passenger to a Map if not null
    };
  }
}
