import 'package:a5er_elshare3/core/utils/constants.dart';
import 'package:a5er_elshare3/core/widgets/RoundedAppBar.dart';
import 'package:a5er_elshare3/features/Trip/data/Database/FirebaseTripStorage.dart';
import 'package:a5er_elshare3/features/Trip/presentation/cubits/TripCubit/trip_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/PassengerTripCard.dart';

class PassengerTripList extends StatelessWidget {
  final String? userEmail;
  const PassengerTripList({super.key, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const RoundedAppBar(
        title: "Trips History",
        height: 140,
        color: kDarkBlueColor,
      ),
      body: BlocProvider(
        create: (context) => TripCubit(tripStorage: FirebaseTripStorage())
          ..fetchAllTrips(userEmail!),
        child: BlocBuilder<TripCubit, TripState>(
          builder: (context, state) {
            if (state is TripLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TripDataFetched) {
              final trips = state.trips;
              print("Trips fetched: ${trips.length} trips");

              if (trips.isEmpty) {
                return const Center(child: Text('No trips found.'));
              }

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: trips.length,
                  itemBuilder: (context, index) {
                    final trip = trips[index];
                    return Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: PassengerTripCard(trip: trip),
                    );
                  },
                ),
              );
            } else if (state is TripError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            return const Center(child: Text('Something went wrong.'));
          },
        ),
      ),
    );
  }
}
