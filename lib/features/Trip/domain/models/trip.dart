import '../../../Driver/domain/models/driver.dart';
import '../../../Passenger/domain/models/Passenger.dart';
import '../../data/Entities/TripEntity.dart';

class Trip extends TripEntity {
  Trip({
    super.id,
    super.date,
    super.time,
    super.FromLocation,
    super.ToDestination,
    super.driver,
    super.passenger,
    super.distance,
    super.Status,
    super.price,
    super.points,
    super.paymentMethod,
  });

  factory Trip.fromMap(Map<String, dynamic> data) {
    return Trip(
      id: data['id'] ?? '',
      date: data['date'] ?? '',
      time: data['time'] ?? '',
      FromLocation: data['FromLocation'] ?? '',
      ToDestination: data['ToDestination'] ?? '',
      Status: data['Status'] ?? '',
      distance: (data['Distance'] is int) ? (data['Distance'] as int).toDouble() : (data['Distance'] ?? 0.0),
      price: (data['Price'] is int) ? (data['Price'] as int).toDouble() : (data['Price'] ?? 0.0),
      points: data['points'] ?? 0,
      paymentMethod: data['paymentMethod'] ?? 'Cash',
      driver: data['driver'] != null ? Driver.fromMap(data['driver'] as Map<String, dynamic>) : null,
      passenger: data['passenger'] != null ? Passenger.fromMap(data['passenger'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'time': time,
      'FromLocation': FromLocation,
      'ToDestination': ToDestination,
      'Status': Status,
      'Distance': distance,
      'Price': price,
      'points': points,
      'paymentMethod': paymentMethod,
      'driver': driver?.toMap(),
      'passenger': passenger?.toMap(),
    };
  }

  Trip copyWith({
    String? id,
    String? date,
    String? time,
    String? fromLocation,
    String? toDestination,
    Driver? driver,
    Passenger? passenger,
    double? distance,
    String? Status,
    double? price,
    int? points,
    String? paymentMethod,
  }) {
    return Trip(
      id: id ?? this.id,
      date: date ?? this.date,
      time: time ?? this.time,
      FromLocation: FromLocation ?? FromLocation,
      ToDestination: ToDestination ?? ToDestination,
      driver: driver ?? this.driver,
      passenger: passenger ?? this.passenger,
      distance: distance ?? this.distance,
      Status: Status ?? this.Status,
      price: price ?? this.price,
      points: points ?? this.points,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }
}
