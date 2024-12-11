import 'package:a5er_elshare3/features/Authentication/data/Database/FirebaseAuthentication.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl package for date/time formatting

import '../../../Passenger/data/Database/FirebasePassengerStorage.dart';
import '../../../Passenger/domain/models/Passenger.dart';
import '../../domain/models/trip.dart';

class PassengerTripCard extends StatelessWidget {
  final Trip trip;

  PassengerTripCard({Key? key, required this.trip}) : super(key: key);
  Authentication auth = Authentication();
  final FirebasePassengerStorage PStorage = FirebasePassengerStorage();

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
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 5,
                      spreadRadius: 2,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Colors.blue),
                        const SizedBox(width: 10),
                        FutureBuilder<String>(
                          future: _formatDate(trip.date!),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                snapshot.data!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            } else {
                              return const Text(
                                "Loading...",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Passenger Name
                    Row(
                      children: [
                        const Icon(Icons.person, color: Colors.green),
                        const SizedBox(width: 10),
                        FutureBuilder<Passenger>(
                          future: PStorage.fetchPassengerData(), // Replace with your actual async method to fetch the passenger's name
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator(); // Show a loading spinner while waiting
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              print(snapshot.data?.name);
                              // If the data is fetched successfully, show the name
                              return Text(
                                'Passenger: ${snapshot.data?.name ?? "N/A"}',
                                style: const TextStyle(fontSize: 16),
                              );
                            }
                          },
                        ),

                      ],
                    ),
                    const SizedBox(height: 10),

                    // Time
                    Row(
                      children: [
                        const Icon(Icons.access_time, color: Colors.orange),
                        const SizedBox(width: 10),
                        Text(
                          'Time: ${trip.time}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // From Location
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.red),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            'From: ${trip.FromLocation}',
                            style: const TextStyle(fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // To Location
                    Row(
                      children: [
                        const Icon(Icons.flag, color: Colors.purple),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            'To: ${trip.ToDestination}',
                            style: const TextStyle(fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Status
                    Row(
                      children: [
                        const Icon(Icons.info, color: Colors.blueAccent),
                        const SizedBox(width: 10),
                        Text(
                          'Status: ${trip.Status}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Distance
                    Row(
                      children: [
                        const Icon(Icons.straighten, color: Colors.teal),
                        const SizedBox(width: 10),
                        Text(
                          'Distance: ${trip.distance?.toStringAsFixed(2)} km',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
