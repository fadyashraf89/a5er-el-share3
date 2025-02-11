import 'package:a5er_elshare3/features/Passenger/data/Entities/PassengerEntity.dart';
import 'package:a5er_elshare3/features/Trip/domain/models/trip.dart';

import '../../../Passenger/domain/models/Passenger.dart';
import '../Cards.dart';

abstract class PaymentRepository {
  Future<void> addCard(Cards card, Passenger passenger);
  dynamic CardPayment(PassengerEntity passenger, Trip trip);
  dynamic CashPayment(PassengerEntity passenger, Trip trip);
  dynamic PointsPayment(PassengerEntity passenger, Trip trip);


}