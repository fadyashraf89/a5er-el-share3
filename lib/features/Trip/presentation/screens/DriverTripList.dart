import 'dart:async';

import 'package:a5er_elshare3/core/utils/Injections/dependency_injection.dart';
import 'package:a5er_elshare3/core/utils/UseCases/FormatDate.dart';
import 'package:a5er_elshare3/features/Trip/domain/UseCases/getActiveTripsStreamUseCase.dart';
import 'package:a5er_elshare3/features/Trip/presentation/cubits/TripCubit/trip_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/utils/Constants/constants.dart';
import '../../../../core/widgets/RoundedAppBar.dart';
import '../../../Driver/domain/models/driver.dart';
import '../../domain/models/trip.dart';
import '../widgets/DriverTripCard.dart';
import 'DriverTripPage.dart';

class DriverTripList extends StatefulWidget {
  final Driver driver;

  const DriverTripList({super.key, required this.driver});

  @override
  State<DriverTripList> createState() => _DriverTripListState();
}

class _DriverTripListState extends State<DriverTripList> {
  Duration expirationTime = const Duration(minutes: 1);
  final FormattedDate formatter = FormattedDate();
  Timer? expirationTimer;
  int currentTripIndex = 0;
  List<Trip> activeTrips = [];

  @override
  void initState() {
    super.initState();
    startTripTimer();
  }

  void startTripTimer() {
    expirationTimer?.cancel();
    if (currentTripIndex < activeTrips.length) {
      expirationTimer = Timer(expirationTime, () {
        if (mounted) {
          setState(() {
            currentTripIndex++;
            if (currentTripIndex >= activeTrips.length) {
              currentTripIndex = 0;
            }
          });
          startTripTimer();
        }
      });
    }
  }

  @override
  void dispose() {
    expirationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const RoundedAppBar(
        title: "Trip Requests",
        height: 140,
        color: kDarkBlueColor,
      ),
      body: BlocConsumer<TripCubit, TripState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is TripAccepted) {
            final trip = state.trip;
            return FutureBuilder<List<LatLng?>>(
              future: Future.wait([
                convertAddressToLatLng(trip.FromLocation ?? "Unknown From"),
                convertAddressToLatLng(trip.ToDestination ?? "Unknown To"),
              ]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final fromLatLng = snapshot.data?[0];
                final toLatLng = snapshot.data?[1];
                if (fromLatLng != null && toLatLng != null) {
                  return TripPage(
                    trip: trip,
                    fromLocation: trip.FromLocation ?? "Unknown From",
                    toLocation: trip.ToDestination ?? "Unknown To",
                    price: trip.price ?? 0.0,
                    passengerName: trip.passenger?.name ?? "Unknown Passenger",
                    passengerPhone: trip.passenger?.mobileNumber ?? "Unknown Phone",
                    fromLatLng: fromLatLng,
                    toLatLng: toLatLng,
                  );
                } else {
                  return const Center(
                    child: Text('Invalid locations. Could not start trip.'),
                  );
                }
              },
            );
          }
          else if (state is TripStarted) {
            final trip = state.trip;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Trip Started",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<TripCubit>().EndTrip(trip);
                    },
                    child: const Text("End Trip"),
                  )
                ],
              ),
            );
          }
          else if (state is TripFinished){
            final trip = state.trip;
            final price = trip.price;
            final name = trip.passenger!.name;
            return Center(
              child: Text("Take \$ $price from $name"),
            );
          }
          else {
            getActiveTripsStreamUseCase active = sl<getActiveTripsStreamUseCase>();
            return StreamBuilder<List<Trip>>(
              stream: active.getActiveTripsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                activeTrips = (snapshot.data ?? []).where((trip) => trip.Status == 'Active').toList();
                if (activeTrips.isEmpty) {
                  return const Center(child: Text('No Active Requests.'));
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: activeTrips.length,
                    itemBuilder: (context, index) {
                      final trip = activeTrips[index];
                      return Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: DriverTripCard(
                          trip: trip,
                          driver: widget.driver,
                          highlight: index == currentTripIndex,
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<LatLng?> convertAddressToLatLng(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        return LatLng(locations.first.latitude, locations.first.longitude);
      } else {
        print('No location found for the address');
        return null;
      }
    } catch (e) {
      print('Error occurred during geocoding: $e');
      return null;
    }
  }
}
