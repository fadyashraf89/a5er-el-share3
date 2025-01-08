import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Driver/data/database/FirebaseDriverStorage.dart';
import '../../../Driver/domain/models/driver.dart';
import '../../domain/models/trip.dart';
import '../cubits/TripCubit/trip_cubit.dart';

class AcceptOrRejectButton extends StatefulWidget {
  const AcceptOrRejectButton({
    super.key,
    required this.trip,
    required this.isAccept,
  });

  final Trip trip;
  final bool isAccept;

  @override
  State<AcceptOrRejectButton> createState() => _AcceptOrRejectButtonState();
}

class _AcceptOrRejectButtonState extends State<AcceptOrRejectButton> {
  @override
  Widget build(BuildContext context) {
    return widget.isAccept
        ? ElevatedButton.icon(
            onPressed: () async {
              Driver? currentDriver =
                  await FirebaseDriverStorage().fetchDriverData();
              try {
                // Perform the asynchronous operation (e.g., accept the trip)
                await context.read<TripCubit>().acceptTrip(
                  widget.trip.passenger?.email ?? "", // Passenger email
                  widget.trip.toMap(), // Trip data
                  currentDriver,
                );

                // Ensure the widget is still mounted before showing Snackbar
                if (!mounted) return;

                // Show success Snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Trip accepted successfully!")),
                );
              } catch (e) {
                // Ensure the widget is still mounted before showing Snackbar
                if (!mounted) return;

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
              backgroundColor: Colors.green,
              // Background color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
          )
        : ElevatedButton.icon(
            onPressed: () async {
              Driver? currentDriver =
                  await FirebaseDriverStorage().fetchDriverData();

              try {
                // Pass the driver data here
                await context.read<TripCubit>().rejectTrip(
                  widget.trip.passenger?.email ?? "", // Passenger email
                  widget.trip.toMap(), // Trip data
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
              backgroundColor: Colors.red,
              // Background color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
          );
  }
}
