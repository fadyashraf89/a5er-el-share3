import 'package:a5er_elshare3/features/Passenger/domain/models/Passenger.dart';

import '../../Trip/domain/models/trip.dart';

abstract class Payment {
  Passenger passenger;
  Trip trip;

  Payment({required this.passenger, required this.trip});
  dynamic Pay(Passenger passenger, Trip trip);
}