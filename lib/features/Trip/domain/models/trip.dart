import '../../../Driver/domain/models/driver.dart';
import '../../../Passenger/domain/models/Passenger.dart';

class Trip {
  String? date, time, FromLocation, ToDestination;
  Driver? driver;
  Passenger? passenger;  // Define as nullable type
  double? distance;
  String? Status;
  double? price;
  int? points;
  String? paymentMethod = 'Cash';

  // Constructor
  Trip({
    this.points,
    this.paymentMethod,
    this.date,
    this.price,
    this.distance,
    this.Status,
    this.time,
    this.FromLocation,
    this.ToDestination,
    this.driver,
    this.passenger,
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
      points: data['points'],
      paymentMethod: data['paymentMethod']
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
      'points': points?.toInt(),
      'paymentMethod':paymentMethod
    };
  }
}
