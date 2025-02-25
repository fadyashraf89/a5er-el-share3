import 'package:a5er_elshare3/features/Trip/domain/models/trip.dart';
import 'package:flutter/material.dart';
class DismissButton extends StatefulWidget {
  const DismissButton({super.key});


  @override
  State<DismissButton> createState() => _DismissButtonState();
}

class _DismissButtonState extends State<DismissButton> {
  final Set<String> skippedTrips = {};
  int currentTripIndex = 0;
  List<Trip> activeTrips = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton.icon(
        onPressed: _skipTrip,
        icon: const Icon(Icons.arrow_forward,
            size: 20, color: Colors.white),
        label: const Text(
          "Dismiss Trip",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.brown,
          // Background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
      ),
    );
  }

  void _skipTrip() {
    setState(() {
      if (currentTripIndex < activeTrips.length) {
        skippedTrips.add(activeTrips[currentTripIndex].id!);
        currentTripIndex++;
      }
    });
  }
}
