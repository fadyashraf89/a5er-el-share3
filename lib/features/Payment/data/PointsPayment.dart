import 'package:a5er_elshare3/features/Passenger/domain/models/Passenger.dart';
import 'package:a5er_elshare3/features/Payment/data/payment.dart';

import '../../Trip/domain/models/trip.dart';

class PointsPayment extends Payment {
  PointsPayment({required super.passenger, required super.trip});

  @override
  dynamic Pay(Passenger passenger, Trip trip) {
    if (trip.Status == "validated".toLowerCase()) {
      if ((passenger.points ?? 0) < (trip.points ?? 0)) {
        throw Exception("Insufficient points to pay for this trip.");
      }

      // Subtract trip points from passenger's points
      passenger.points = (passenger.points ?? 0) - (trip.points ?? 0);

      // Optional: Return a confirmation message or the updated passenger object
      return "Payment successful. Remaining points: ${passenger.points}";
    }

      // // Subtract trip points from passenger's points
      // passenger.points = (passenger.points ?? 0) - (trip.points ?? 0);
      //
      // // Optional: Return a confirmation message or the updated passenger object
      // return "Payment successful. Remaining points: ${passenger.points}";
    }
}
