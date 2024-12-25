import 'package:a5er_elshare3/features/Trip/data/Database/FirebaseTripStorage.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/FormatedDate.dart';
import '../../../Driver/domain/models/driver.dart';
import '../../domain/models/trip.dart';
import 'AcceptOrRejectButton.dart';

class DriverTripCard extends StatelessWidget {
  final Trip trip;
  final Driver driver; // Add Driver as a parameter
  final FirebaseTripStorage storage = FirebaseTripStorage();
  DriverTripCard({Key? key, required this.trip, required this.driver}) : super(key: key);

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
                          future: FormattedDate().FormatDate(trip.date!),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AcceptOrRejectButton(trip: trip, isAccept: true,),
                        AcceptOrRejectButton(trip: trip, isAccept: false,),
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

