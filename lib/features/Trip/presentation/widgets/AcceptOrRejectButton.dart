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
                await context.read<TripCubit>().acceptTrip(
                  widget.trip.passenger?.email ?? "",
                  widget.trip.toMap(),
                  currentDriver,
                );
                if (!mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Trip accepted successfully!")),
                );
              } catch (e) {
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
                await context.read<TripCubit>().rejectTrip(
                  widget.trip.passenger?.email ?? "",
                  widget.trip.toMap(),
                  currentDriver,
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
