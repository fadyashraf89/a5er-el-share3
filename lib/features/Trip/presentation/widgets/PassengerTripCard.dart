import 'package:a5er_elshare3/dependency_injection.dart';
import 'package:a5er_elshare3/features/Passenger/domain/UseCases/FetchPassengerDataUseCase.dart';
import 'package:flutter/material.dart';
// Import intl package for date/time formatting

import '../../../../core/utils/FormatedDate.dart';
import '../../../Passenger/domain/models/Passenger.dart';
import '../../domain/models/trip.dart';

class PassengerTripCard extends StatefulWidget {
  final Trip trip;

  const PassengerTripCard({super.key, required this.trip});

  @override
  State<PassengerTripCard> createState() => _PassengerTripCardState();
}

class _PassengerTripCardState extends State<PassengerTripCard> {
  FetchPassengerDataUseCase fetchPassengerDataUseCase = sl<FetchPassengerDataUseCase>();


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
                          future:FormattedDate().formatToReadableDate(widget.trip.date!),
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
                          future: fetchPassengerDataUseCase.fetchPassengerData(), // Replace with your actual async method to fetch the passenger's name
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
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
                          'Time: ${widget.trip.time}',
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
                            'From: ${widget.trip.FromLocation}',
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
                            'To: ${widget.trip.ToDestination}',
                            style: const TextStyle(fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.stars_rounded, color: Colors.yellow),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            'Points: ${widget.trip.points}',
                            style: const TextStyle(fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.money, color: Colors.green),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            'Price: ${widget.trip.price}',
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
                          'Distance: ${widget.trip.distance?.toStringAsFixed(2)} km',
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
}
