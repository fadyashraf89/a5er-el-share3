import 'package:a5er_elshare3/features/Trip/data/Database/FirebaseTripStorage.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/FormatedDate.dart';
import '../../../Driver/domain/models/driver.dart';
import '../../domain/models/trip.dart';
import 'AcceptButton.dart';

class DriverTripCard extends StatelessWidget {
  final Trip trip;
  final Driver driver;
  final FirebaseTripStorage storage = FirebaseTripStorage();
  DriverTripCard({super.key, required this.trip, required this.driver});

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
                          // Using the Future to format the date
                          future: FormattedDate().formatToReadableDate(trip.date!),  // Make sure trip.date is not null
                          builder: (context, snapshot) {
                            // Handling loading state
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Text(
                                "Loading...",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                            // Handling error state
                            if (snapshot.hasError) {
                              return const Text(
                                "Invalid date",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              );
                            }
                            // Display formatted date when data is ready
                            if (snapshot.hasData) {
                              return Text(
                                snapshot.data!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                            return const Text(
                              "No Date Available",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            );
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
                        Text(
                          'Passenger: ${trip.passenger?.name ?? "N/A"}',
                          style: const TextStyle(fontSize: 16),
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
                    Row(
                      children: [
                        const Icon(Icons.money, color: Colors.lightGreen),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            'Price: ${trip.price}',
                            style: const TextStyle(fontSize: 16),
                            overflow: TextOverflow.ellipsis,
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
                    const SizedBox(height: 10),

                    Row(
                      children: [
                        const Icon(Icons.watch_later, color: Colors.yellow),
                        const SizedBox(width: 10),
                        Text(
                          'Status: ${trip.Status} ',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AcceptButton(trip: trip),
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
}

