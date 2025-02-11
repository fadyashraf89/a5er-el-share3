import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/Injections/dependency_injection.dart';
import '../../../Driver/domain/UseCases/FetchDriverDataUseCase.dart';
import '../../../Driver/domain/models/driver.dart';
import '../../domain/models/trip.dart';
import '../cubits/TripCubit/trip_cubit.dart';

class AcceptButton extends StatefulWidget {
  const AcceptButton({
    super.key,
    required this.trip,
  });

  final Trip trip;

  // final bool isAccept;

  @override
  State<AcceptButton> createState() => _AcceptButtonState();
}

class _AcceptButtonState extends State<AcceptButton> {
  FetchDriverDataUseCase fetchDriverDataUseCase = sl<FetchDriverDataUseCase>();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        Driver? currentDriver = await fetchDriverDataUseCase.fetchDriverData();
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
    );
  }
}
