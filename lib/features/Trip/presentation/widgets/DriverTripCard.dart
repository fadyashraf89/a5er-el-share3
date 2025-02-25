import 'package:flutter/material.dart';
import '../../../../core/utils/UseCases/FormatDate.dart';
import '../../../Driver/domain/models/driver.dart';
import '../../domain/models/trip.dart';
import 'AcceptButton.dart';
import 'DismissTripButton.dart';

class DriverTripCard extends StatelessWidget {
  final Trip trip;
  final Driver driver;
  final bool highlight; // Add highlight parameter

  const DriverTripCard({
    super.key,
    required this.trip,
    required this.driver,
    this.highlight = false, // Default to false
  });

  Widget _buildRow(IconData icon, String text, Color iconColor) {
    return Row(
      children: [
        Icon(icon, color: iconColor),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        color: highlight ? Colors.blue.shade100 : Colors.white, // Apply highlighting

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
                          future: FormattedDate().formatToReadableDate(trip.date!),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Text(
                                "Loading...",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              );
                            }
                            if (snapshot.hasError) {
                              return const Text(
                                "Invalid date",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
                              );
                            }
                            return Text(
                              snapshot.data ?? "No Date Available",
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Passenger Name
                    _buildRow(Icons.person, 'Passenger: ${trip.passenger?.name ?? "N/A"}', Colors.green),
                    const SizedBox(height: 10),

                    // Time
                    _buildRow(Icons.access_time, 'Time: ${trip.time}', Colors.orange),
                    const SizedBox(height: 10),

                    // From Location
                    _buildRow(Icons.location_on, 'From: ${trip.FromLocation}', Colors.red),
                    const SizedBox(height: 10),

                    // To Location
                    _buildRow(Icons.flag, 'To: ${trip.ToDestination}', Colors.purple),
                    const SizedBox(height: 10),

                    // Price
                    _buildRow(Icons.money, 'Price: ${trip.price}', Colors.lightGreen),
                    const SizedBox(height: 10),

                    // Distance
                    _buildRow(Icons.straighten, 'Distance: ${trip.distance?.toStringAsFixed(2)} km', Colors.teal),
                    const SizedBox(height: 10),

                    // Status
                    _buildRow(Icons.watch_later, 'Status: ${trip.Status}', Colors.yellow),
                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const DismissButton(),
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
