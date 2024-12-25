import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_google_maps_webservices/places.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter_api/google_places_flutter_api.dart';
import 'package:geocoding/geocoding.dart' as geocoding;

import '../../../../core/utils/constants.dart';
import '../../../GoogleMaps/Presentation/cubits/MapsCubit/maps_cubit.dart';

class PlacesSearchField {
  Widget BuildPlaceSearchField(
    String hint,
    IconData icon,
    TextEditingController controller,
    BuildContext ctx1, {
    required bool isPickup,
  }) {
    return BlocConsumer<MapsCubit, MapsState>(
      listener: (context, state) {
        if (state is MapsLoaded) {
          controller.text = isPickup
              ? state.pickupLocation ?? ""
              : state.destinationLocation ?? "";
        }
        if (state is MapsError) {
          ScaffoldMessenger.of(ctx1).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () async {
            try {
              if (ApiKey.isEmpty) {
                throw Exception("Missing Places API Key");
              }

              Prediction? prediction = await PlacesAutocomplete.show(
                context: ctx1,
                apiKey: ApiKey,
                mode: Mode.fullscreen,
                language: "en",
              );

              if (prediction != null) {
                List<geocoding.Location> locations =
                    await locationFromAddress(prediction.description ?? "");
                if (locations.isNotEmpty) {
                  geocoding.Location location = locations.first;
                  LatLng latLng = LatLng(location.latitude, location.longitude);
                  String locationName = prediction.description ?? "";

                  // Updating state after fetching the location.
                  ctx1.read<MapsCubit>().updateCurrentLocation(
                        latLng,
                        locationName,
                        isPickup,
                      );
                }
              }
            } catch (e) {
              print("Error fetching place: ${e.toString()}");
              ScaffoldMessenger.of(ctx1).showSnackBar(
                SnackBar(
                    content: Text("Error fetching place: ${e.toString()}")),
              );
            }
          },
          child: Column(
            children: [
              AbsorbPointer(
                child: TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: hint,
                    prefixIcon: Icon(icon),
                    border: const OutlineInputBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kDarkBlueColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(20)),
                  ),
                ),
                onPressed: () async {
                  // Get current location when button is pressed
                  await ctx1
                      .read<MapsCubit>()
                      .getCurrentLocation(isPickup: isPickup);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.gps_fixed, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      "Your Current Location",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Archivo",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
