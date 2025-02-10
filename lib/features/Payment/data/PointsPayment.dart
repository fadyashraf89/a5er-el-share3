import 'package:a5er_elshare3/features/Payment/data/payment.dart';

import '../../Passenger/data/Entities/PassengerEntity.dart';
import '../../Trip/domain/models/trip.dart';

class PointsPayment extends Payment {
  PointsPayment({required super.passenger, required super.trip});

  @override
  dynamic Pay(PassengerEntity passenger, Trip trip) {
    if (trip.Status == "validated".toLowerCase()) {
      if ((passenger.points ?? 0) < (trip.points ?? 0)) {
        throw Exception("Insufficient points to pay for this trip.");
      }

      passenger.points = (passenger.points ?? 0) - (trip.points ?? 0);

      return "Payment successful. Remaining points: ${passenger.points}";
    }


    }
}
