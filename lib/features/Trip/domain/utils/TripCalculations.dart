import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../presentation/cubits/TripCubit/trip_cubit.dart';

class TripCalculations {
  double calculateDistance(LatLng point1, LatLng point2, BuildContext context) {
    double distanceInKilometers =
    context.read<TripCubit>().calculateDistance(point1, point2);

    return distanceInKilometers;

  }

  double calculatePrice(double distanceInKilometers, BuildContext context) {
    double price = context.read<TripCubit>().calculatePrice(distanceInKilometers);
    return double.parse(price.toStringAsFixed(2));
  }

  int calculateTripPoints(double price, BuildContext context){
    int points = price.round();
    return points;
  }
}