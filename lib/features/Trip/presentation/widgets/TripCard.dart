import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl package for date/time formatting

import "../../data/models/trip.dart";

class TripCard extends StatelessWidget {
  final Trip trip;

  const TripCard({Key? key, required this.trip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Card(

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              FutureBuilder<String>(
                future: _formatDate(trip.date!),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text('Date: ${snapshot.data}');
                  } else {
                    return const Text('Date: Loading...');
                  }
                },
              ),
              Text('Passenger Name: ${trip.passenger?.name }'),
              Text('Time: ${trip.time}'),
              Text('From: ${trip.FromLocation}'),
              Text('To: ${trip.ToDestination}'),
              Text('Status: ${trip.Status}'),
              Text('Distance: ${trip.distance?.toStringAsFixed(2)} km'),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> _formatDate(String dateString) async {
    final formatter = DateFormat('yyyy-MM-dd');
    final date = formatter.parse(dateString);
    final formattedDate = DateFormat.yMMMMd().format(date);
    return formattedDate;
  }

}