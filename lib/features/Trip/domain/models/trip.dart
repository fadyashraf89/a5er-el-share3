import '../../../Driver/domain/models/driver.dart';
import '../../../Passenger/domain/models/Passenger.dart';

class Trip {
  final String? date, time, FromLocation, ToDestination;
  final Driver? driver;
  final Passenger? passenger;
  final double? distance;
  final String? Status;
  final double? price;
  final int? points;

  Trip({this.points,
      required this.date,
      required this.price,
      required this.distance,
      required this.Status,
      required this.time,
      required this.FromLocation,
      required this.ToDestination,
      required this.driver,
      required this.passenger,
  });

  factory Trip.fromMap(Map<dynamic, dynamic> data) {
    return Trip(
      distance: (data['Distance'] is int)
          ? (data['Distance'] as int).toDouble()  // Convert int to double if necessary
          : data['Distance'] as double?,  // Already a double or null
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
      price: (data['Price'] is int)
          ? (data['Price'] as int).toDouble()  // Convert int to double if necessary
          : data['Price'] as double?,  // Already a double or null
      points: data['points']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'time': time,
      'FromLocation': FromLocation,
      'ToDestination': ToDestination,
      'Status': Status,
      'Distance': distance?.toDouble(),
      'driver': driver?.toMap(), // Convert driver to a Map if not null
      'passenger': passenger?.toMap(),
      'Price': price?.toDouble(),
      'points': points?.toInt()
    };
  }
}
