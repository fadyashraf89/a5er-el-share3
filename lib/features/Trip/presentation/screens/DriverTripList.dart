import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/RoundedAppBar.dart';
import '../../../Driver/data/models/driver.dart';
import '../../data/models/trip.dart';
import '../widgets/DriverTripCard.dart';

class DriverTripList extends StatefulWidget {
  final Driver driver;  // Accept Driver as a parameter

  const DriverTripList({super.key, required this.driver});  // Constructor requires driver

  @override
  State<DriverTripList> createState() => _DriverTripListState();
}

class _DriverTripListState extends State<DriverTripList> {

  @override
  void initState() {
    super.initState();
  }
  Stream<List<Trip>> _getRequestedTripsStream() => FirebaseFirestore.instance
      .collection('Trips')
      .snapshots()
      .map((snapshot) {
    List<Trip> requestedTrips = [];
    for (var doc in snapshot.docs) {
      final data = doc.data();
      final List<dynamic> tripDataList = data['trips'] ?? [];

      // Filter trips by status 'requested'
      for (var tripData in tripDataList) {
        if (tripData['Status'] == 'Requested') {
          requestedTrips.add(Trip.fromMap(tripData as Map<String, dynamic>));
        }
      }

    }
    return requestedTrips;
  });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const RoundedAppBar(
        title: "Trip Requests",
        height: 140,
        color: kDarkBlueColor,
      ),
      body: StreamBuilder<List<Trip>>(
        stream: _getRequestedTripsStream(),  // Listen to the stream of requested trips
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
