import 'package:a5er_elshare3/features/Trip/domain/models/trip.dart';
import 'package:a5er_elshare3/features/Trip/presentation/cubits/TripCubit/trip_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/Injections/dependency_injection.dart';
import '../../../Driver/domain/UseCases/FetchDriverDataUseCase.dart';
import '../../../Driver/domain/models/driver.dart';
class DismissButton extends StatefulWidget {
  final Trip trip;
  final Driver driver;
  const DismissButton({super.key, required this.trip, required this.driver});

  @override
  State<DismissButton> createState() => _DismissButtonState();
}

class _DismissButtonState extends State<DismissButton> {
  FetchDriverDataUseCase fetchDriverDataUseCase = sl<FetchDriverDataUseCase>();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        Driver? currentDriver = await fetchDriverDataUseCase.fetchDriverData();
        try {
          await context.read<TripCubit>().DismissTrip(
            widget.trip,
            currentDriver,
          );
          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Trip Dismissed successfully!")),
          );
        } catch (e) {
          if (!mounted) return;
          print(e);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error Dismissing trip: $e")),
          );
        }
      },
      icon: const Icon(Icons.arrow_forward, size: 20, color: Colors.white),
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    );
  }
}
