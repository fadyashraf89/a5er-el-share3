import 'package:a5er_elshare3/features/GoogleMaps/Presentation/cubits/MapsCubit/maps_cubit.dart';
import 'package:a5er_elshare3/features/Trip/domain/models/trip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../GoogleMaps/Presentation/screens/MapsView.dart';
import '../../../../core/utils/constants.dart';
import '../cubits/TripCubit/trip_cubit.dart';  // Make sure kDarkBlueColor is defined in this file

class TripPage extends StatefulWidget {
  final String fromLocation;
  final String toLocation;
  final double price;
  final String passengerName;
  final String passengerPhone;
  final LatLng fromLatLng;
  final LatLng toLatLng;
  final Trip trip;

  const TripPage({
    super.key,
    required this.fromLocation,
    required this.toLocation,
    required this.price,
    required this.passengerName,
    required this.passengerPhone,
    required this.fromLatLng,
    required this.toLatLng,
    required this.trip
  });

  @override
  _TripPageState createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  late GoogleMapController mapController;

  void _startTrip() {
    context.read<TripCubit>().StartTrip(widget.trip);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Use the MapsView widget to display the map with markers
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: MapsView(
                  currentLocation: widget.fromLatLng,
                  markers: {
                    Marker(
                      markerId: MarkerId('fromLocation'),
                      position: widget.fromLatLng,
                      infoWindow: InfoWindow(title: 'From Location'),
                    ),
                    Marker(
                      markerId: MarkerId('toLocation'),
                      position: widget.toLatLng,
                      infoWindow: InfoWindow(title: 'To Location'),
                    ),
                  },
                  onMapCreated: (controller) {
                    mapController = controller;
                  },
                ),
              ),
            ),
          ),

          // Trip and Passenger Information
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Trip Information
                Text("From: ${widget.fromLocation}",
                    style: TextStyle(fontSize: 16, color: kDarkBlueColor)),
                Text("To: ${widget.toLocation}",
                    style: TextStyle(fontSize: 16, color: kDarkBlueColor)),
                Text("Price: \$${widget.price.toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 16, color: kDarkBlueColor)),
                const SizedBox(height: 10),

                // Passenger Information
                Text("Passenger: ${widget.passengerName}",
                    style: TextStyle(fontSize: 16, color: kDarkBlueColor)),
                Text("Phone: ${widget.passengerPhone}",
                    style: TextStyle(fontSize: 16, color: kDarkBlueColor)),
                const SizedBox(height: 20),

                // Start Trip Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _startTrip,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kDarkBlueColor,  // Background color for button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        "Start the Trip",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
