import 'package:a5er_elshare3/core/utils/constants.dart';
import 'package:a5er_elshare3/core/widgets/RoundedAppBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../data/Database/TripStorage.dart';
import '../../data/models/trip.dart';
import '../widgets/TripCard.dart';

class TripList extends StatefulWidget {
  const TripList({super.key});

  @override
  State<TripList> createState() => _TripListState();
}

class _TripListState extends State<TripList> {
  List<Trip> _trips = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchTrips();
  }

  Future<void> _fetchTrips() async {
    setState(() {
      _isLoading = true; // Set loading state to true
    });

    try {
      final trips = await TripStorage().fetchTripsForLoggedInUser();
      setState(() {
        _trips = trips;
        _isLoading = false;
      });
      print('Fetched Trips: $_trips');
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching trips: ${e.message}'),
        ),
      );
    } catch (e) {
      // Catch other general exceptions and provide generic error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('An unexpected error occurred. Please try again later.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const RoundedAppBar(
        title: "Trips List",
        height: 140,
        color: kDarkBlueColor,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _trips.isEmpty
              ? const Center(
                  child:
                      Text('No trips found.')) // Display message for no trips
              : Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    itemCount: _trips.length,
                    itemBuilder: (context, index) {
                      final trip = _trips[index];
                      return Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: TripCard(trip: trip),
                      );
                    },
                  ),
              ),
    );
  }
}