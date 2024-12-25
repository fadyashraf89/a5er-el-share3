import 'package:flutter/material.dart';

import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/RoundedAppBar.dart';
import '../../../Driver/domain/models/driver.dart';
import '../../data/Database/FirebaseTripStorage.dart';
import '../../domain/models/trip.dart';
import '../widgets/DriverTripCard.dart';

class DriverTripList extends StatefulWidget {
  final Driver driver;  // Accept Driver as a parameter

  const DriverTripList({super.key, required this.driver});  // Constructor requires driver

  @override
  State<DriverTripList> createState() => _DriverTripListState();
}

class _DriverTripListState extends State<DriverTripList> {
  FirebaseTripStorage TStorage = FirebaseTripStorage();
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const RoundedAppBar(
        title: "Trip Requests",
        height: 140,
        color: kDarkBlueColor,
      ),
      body: StreamBuilder<List<Trip>>(
        stream: TStorage.getRequestedTripsStream(),  // Listen to the stream of requested trips
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final trips = snapshot.data ?? [];

          if (trips.isEmpty) {
            return const Center(child: Text('No Pending requests.'));
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: trips.length,
              itemBuilder: (context, index) {
                final trip = trips[index];
                return Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: DriverTripCard(
                    trip: trip,
                    driver: widget.driver, // Pass the driver directly from widget
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
