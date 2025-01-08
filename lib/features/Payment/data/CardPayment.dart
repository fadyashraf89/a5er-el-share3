import 'package:a5er_elshare3/features/Passenger/domain/models/Passenger.dart';
import 'package:a5er_elshare3/features/Payment/data/payment.dart';
import 'package:flutter/material.dart';

import '../../Trip/domain/models/trip.dart';
import '../presentation/CardPaymentScreen.dart';

class CardPayment extends Payment {
  CardPayment({required super.passenger, required super.trip});

  @override
  dynamic Pay(Passenger passenger, Trip trip) {
    return (BuildContext context) {
      print("hne3mel push lel saf7a");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CardPaymentScreen(
            selectedPaymentMethod: "Card",
            passenger: passenger,
            trip: trip,
          ),
        ),
      );
    };
  }

}