import 'package:a5er_elshare3/core/utils/FormatedDate.dart';
import 'package:a5er_elshare3/features/Trip/presentation/cubits/TripCubit/trip_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/RoundedAppBar.dart';
import '../../../Driver/domain/models/driver.dart';
import '../../data/Database/FirebaseTripStorage.dart';
import '../../domain/models/trip.dart';
import '../widgets/DriverTripCard.dart';

class DriverTripList extends StatefulWidget {
  final Driver driver;

  const DriverTripList({super.key, required this.driver});

  @override
  State<DriverTripList> createState() => _DriverTripListState();
}

class _DriverTripListState extends State<DriverTripList> {
  FirebaseTripStorage TStorage = FirebaseTripStorage();
  Duration expirationTime = const Duration(minutes: 5);
  final FormattedDate formatter = FormattedDate();

  Future<bool> isRequestExpired(String tripDate) async {
    try {
      // Parse tripDate into DateTime
      DateTime requestDateTime = formatter.parseToCorrectFormat(tripDate);

      // Get current DateTime
      DateTime currentDateTime = DateTime.now();

      // Compare the difference
      return currentDateTime.difference(requestDateTime) > expirationTime;
    } catch (e) {
      print('Error parsing date: $tripDate, $e');
      return true; // Default to expired in case of an error
    }
  }

  Stream<List<Trip>> getFilteredTrips() async* {
    await for (var trips in TStorage.getActiveTripsTripsStream()) {
      List<Trip> activeTrips = [];
      for (var trip in trips) {
        activeTrips.add(trip);

        // if (trip.date != null) {
        //   bool isExpired = await isRequestExpired(trip.date!);
        //   if (!isExpired && trip.Status == 'Requested') {
        //     activeTrips.add(trip);
        //   }
        // }
      }
      print(activeTrips);
      yield activeTrips;
    }
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
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          if (state is TripAccepted) {
            return const Center(child: Text("El screen ely ba3d ma y3mel accept lel request"));
          } else {
            return StreamBuilder<List<Trip>>(
              stream: TStorage.getActiveTripsTripsStream(),
              // Use the active trips stream
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                // Filter only trips with Status == 'Active'
                final activeTrips = (snapshot.data ?? []).where((trip) {
                  return trip.Status == 'Active';
                }).toList();

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
}
