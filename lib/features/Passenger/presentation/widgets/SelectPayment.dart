import 'package:a5er_elshare3/core/utils/constants.dart';
import 'package:a5er_elshare3/core/validators/validators.dart';
import 'package:a5er_elshare3/features/Payment/presentation/CardPaymentScreen.dart';
import 'package:flutter/material.dart';
import 'package:a5er_elshare3/features/Passenger/domain/models/Passenger.dart';
import 'package:a5er_elshare3/features/Payment/data/payment.dart';
import 'package:a5er_elshare3/features/Payment/data/CardPayment.dart';
import 'package:a5er_elshare3/features/Payment/data/CashPayment.dart';
import 'package:a5er_elshare3/features/Trip/domain/models/trip.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SelectPayment extends StatefulWidget {
  final ValueChanged<String> onPaymentMethodChanged;

  const SelectPayment({
    super.key,
    required this.onPaymentMethodChanged,
  });

  @override
  State<SelectPayment> createState() => _SelectPaymentState();
}

class _SelectPaymentState extends State<SelectPayment> {
  String? _selectedMethod;

  void _onSelectPayment(String method) {
    setState(() {
      _selectedMethod = method;
    });
    widget.onPaymentMethodChanged(method);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 16.0),
          child: Text(
            "Choose Payment Method",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: kDarkBlueColor,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildPaymentOptionCard(
              context,
              icon: Icons.attach_money,
              title: "Cash",
              method: "Cash",
              color: Colors.green,
            ),
            _buildPaymentOptionCard(
              context,
              icon: Icons.credit_card,
              title: "Card",
              method: "Card",
              color: Colors.blue,
            ),
            _buildPaymentOptionCard(
              context,
              icon: LucideIcons.gift,
              title: "Points",
              method: "Points",
              color: Colors.orange,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentOptionCard(BuildContext context,
      {required IconData icon,
        required String title,
        required String method,
        required Color color}) {
    bool isSelected = _selectedMethod == method;

    return GestureDetector(
      onTap: () {
        _onSelectPayment(method);
        if (method == "Card") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CardPaymentScreen(
                selectedPaymentMethod: method,
                passenger: Passenger(),
                trip: Trip(passenger: Passenger()),
              ),
            ),
          );
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.9) : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: color.withOpacity(0.6),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ]
              : [],
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: 2,
          ),
        ),
        height: 120,
        width: MediaQuery.of(context).size.width * 0.28,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : color,
              size: 36,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
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
