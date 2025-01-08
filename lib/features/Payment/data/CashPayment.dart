import 'package:a5er_elshare3/features/Passenger/domain/models/Passenger.dart';
import 'package:a5er_elshare3/features/Payment/data/payment.dart';
import 'package:a5er_elshare3/features/Trip/domain/models/trip.dart';

class CashPayment extends Payment {
  CashPayment({required super.passenger, required super.trip});

  @override
  void Pay(Passenger passenger, Trip trip) {
    print("Payment By Cash");
  }
}
