import 'package:a5er_elshare3/features/Passenger/domain/models/Passenger.dart';
import 'package:flutter/material.dart';

import '../../../Driver/data/database/FirebaseDriverStorage.dart';
import '../../../Driver/domain/models/driver.dart';
import '../../data/Database/FirebaseTripStorage.dart';
import '../../domain/models/trip.dart';
class AcceptOrRejectButton extends StatelessWidget {
  const AcceptOrRejectButton({
    super.key,
    required this.trip, required this.isAccept,
  });

  final Trip trip;
  final bool isAccept;

  @override
  Widget build(BuildContext context) {
    return isAccept ?
    ElevatedButton.icon(
      onPressed: () async {
        Driver? currentDriver = await FirebaseDriverStorage().fetchDriverData();
        try {
          // Pass the driver data here
          await FirebaseTripStorage().acceptTrip(
            trip.passenger?.email ?? "", // Passenger email
            trip.toMap(), // Trip data
            currentDriver,

          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Trip accepted successfully!")),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error accepting trip: $e")),
          );
        }
      },
      icon: const Icon(Icons.done, size: 20, color: Colors.white),
      label: const Text(
        "Accept Trip",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green, // Background color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    ) :
    ElevatedButton.icon(
      onPressed: () async {
        Driver? currentDriver = await FirebaseDriverStorage().fetchDriverData();

        try {
          // Pass the driver data here
          await FirebaseTripStorage().RejectTrip(
            trip.passenger?.email ?? "", // Passenger email
            trip.toMap(), // Trip data
            currentDriver, // Driver data passed here
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Trip rejected successfully!")),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error rejecting trip: $e")),
          );
        }
      },
      icon: const Icon(Icons.close, size: 20, color: Colors.white),
      label: const Text(
        "Reject Trip",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red, // Background color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    );
  }
}
