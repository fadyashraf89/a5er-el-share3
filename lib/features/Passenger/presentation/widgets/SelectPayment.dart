import 'package:a5er_elshare3/core/utils/constants.dart';
import 'package:a5er_elshare3/core/validators/validators.dart';
import 'package:a5er_elshare3/features/Payment/presentation/CardPaymentScreen.dart';
import 'package:flutter/material.dart';
import 'package:a5er_elshare3/features/Passenger/domain/models/Passenger.dart';
import 'package:a5er_elshare3/features/Payment/data/payment.dart';
import 'package:a5er_elshare3/features/Payment/data/CardPayment.dart';
import 'package:a5er_elshare3/features/Payment/data/CashPayment.dart';
import 'package:a5er_elshare3/features/Trip/domain/models/trip.dart';

class SelectPayment extends StatefulWidget {
  final ValueChanged<String> onPaymentMethodChanged;
  late Passenger? passenger;
  late Trip? trip;
  SelectPayment({super.key, required this.onPaymentMethodChanged, this.passenger, this.trip});

  @override
  State<SelectPayment> createState() => _SelectPaymentState();
}

class _SelectPaymentState extends State<SelectPayment> {
  String? _selectedMethod;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RadioListTile<String>(
          title: const Text(
            "Cash",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          value: "Cash",
          groupValue: _selectedMethod,
          onChanged: (value) {
            setState(() {
              _selectedMethod = value ?? "Cash";
            });
            widget.onPaymentMethodChanged(_selectedMethod ?? "Cash");
          },
          activeColor: kDarkBlueColor,
        ),
        RadioListTile<String>(
          title: const Text(
            "Card",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          value: "Card",
          groupValue: _selectedMethod,
          onChanged: (value) {
            setState(() {
              _selectedMethod = value ?? "Card";
            });
            widget.onPaymentMethodChanged(_selectedMethod ?? "Card");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CardPaymentScreen(
                  selectedPaymentMethod: _selectedMethod!,
                  passenger: Passenger(),
                  trip: Trip(passenger: Passenger()), // Pass trip data
                ),
              ),
            );

          },
          activeColor: kDarkBlueColor,
        ),
        RadioListTile<String>(
          title: const Text(
            "Points",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          value: "Points",
          groupValue: _selectedMethod,
          onChanged: (value) {
            setState(() {
              _selectedMethod = value ?? "Points";
            });
            widget.onPaymentMethodChanged(_selectedMethod ?? "Points");
          },
          activeColor: kDarkBlueColor,
        ),
      ],
    );
  }
}

dynamic SelectPaymentMethod(String method, Passenger passenger, Trip trip) {
  Payment pay;
  switch (method) {
    case "Cash":
      pay = CashPayment(passenger: passenger, trip: trip);
      pay.Pay(passenger, trip);
      break;
    case "Card":
      pay = CardPayment(passenger: passenger, trip: trip);
      pay.Pay(passenger, trip);
    case "Points":
      Validators validators = Validators();
      if (validators.validatePoints(trip.points ?? 0, passenger.points ?? 0)) {
        return "Validated";
      } else {
        return "Not Validated";
      }
    default:
      pay = CashPayment(passenger: passenger, trip: trip);
      pay.Pay(passenger, trip);
  }
  return method;
}
