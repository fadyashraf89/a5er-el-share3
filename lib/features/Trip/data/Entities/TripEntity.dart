import '../../../Driver/domain/models/driver.dart';
import '../../../Passenger/domain/models/Passenger.dart';

class TripEntity {
  final String? date;
  final String? time;
  final String? FromLocation;
  final String? ToDestination;
  final Driver? driver;
  final Passenger? passenger;
  final double? distance;
  final String? Status;
  final double? price;
  final int? points;
  final String? paymentMethod;

  const TripEntity({
    this.date,
    this.time,
    this.FromLocation,
    this.ToDestination,
    this.driver,
    this.passenger,
    this.distance,
    this.Status,
    this.price,
    this.points,
    this.paymentMethod,
  });
}
