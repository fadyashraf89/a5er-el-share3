import "package:a5er_elshare3/features/Passenger/presentation/widgets/MessageDialog.dart";
import "package:a5er_elshare3/features/Passenger/presentation/widgets/PlacesSearchField.dart";
import "package:a5er_elshare3/features/Trip/domain/calculations/TripCalculations.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";

import "../../../../core/utils/constants.dart";
import "../../../GoogleMaps/Presentation/cubits/MapsCubit/maps_cubit.dart";
import "../../../Trip/domain/models/trip.dart";
import "../../../Trip/presentation/cubits/TripCubit/trip_cubit.dart";
import "../../data/Database/FirebasePassengerStorage.dart";
import "../../domain/models/Passenger.dart";
class TripDetailsSheet {
  final TextEditingController pickUpController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final FirebasePassengerStorage PStorage = FirebasePassengerStorage();

  void showTripDetailsSheet(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: BlocConsumer<TripCubit, TripState>(listener: (_, state) {
            if (state is TripRequestSuccess) {
              MessageDialog().ShowDialog(
                context,
                title: "Success ✅",
                content: state.message,
              );
            } else if (state is TripError) {
              MessageDialog().ShowDialog(
                context,
                title: "Error ❌",
                content: state.message,
              );
            }
          }, builder: (context, state) {
            return DraggableScrollableSheet(
              initialChildSize: 0.5,
              minChildSize: 0.2,
              maxChildSize: 0.9,
              expand: false,
              builder: (context, scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              height: 5,
                              width: 50,
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const Text(
                            "Trip Details",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              fontFamily: "Archivo",
                              color: kDarkBlueColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          PlacesSearchField().BuildPlaceSearchField(
                            "Enter Pick-Up Point",
                            Icons.pin_drop,
                            pickUpController,
                            context,
                            isPickup: true,
                          ),
                          const SizedBox(height: 15),
                          PlacesSearchField().BuildPlaceSearchField(
                            "Enter Destination",
                            Icons.map_outlined,
                            destinationController,
                            context,
                            isPickup: false,
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                print(
                                    "pickup location: ${pickUpController.text} \n "
                                        "destination location: ${destinationController.text}");
                                if (pickUpController.text.isEmpty ||
                                    destinationController.text.isEmpty) {
                                  MessageDialog().ShowDialog(
                                    context,
                                    title: "Error ❌",
                                    content: "Both fields are required.",
                                  );
                                  return;
                                }

                                if (pickUpController.text ==
                                    destinationController.text) {
                                  MessageDialog().ShowDialog(
                                    context,
                                    title: "Error ❌",
                                    content:
                                    "Pickup and Destination cannot be the same.",
                                  );
                                  return;
                                }

                                if (!formKey.currentState!.validate()) {
                                  MessageDialog().ShowDialog(
                                    context,
                                    title: "Error ❌",
                                    content: "Please correct the errors.",
                                  );
                                  return;
                                }

                                // Trigger the Cubit to add a trip
                                try {
                                  final currentState = context
                                      .read<MapsCubit>()
                                      .state as MapsLoaded;
                                  final pickupMarker = currentState.markers
                                      .firstWhere(
                                          (marker) =>
                                      marker.markerId ==
                                          const MarkerId('pickup'),
                                      orElse: () => throw Exception(
                                          "Pickup location not set!"));

                                  final destinationMarker = currentState.markers
                                      .firstWhere(
                                          (marker) =>
                                      marker.markerId ==
                                          const MarkerId('destination'),
                                      orElse: () => throw Exception(
                                          "Destination location not set!"));

                                  LatLng pickupLocation = pickupMarker.position;
                                  LatLng destinationLocation =
                                      destinationMarker.position;

                                  double distance = TripCalculations().calculateDistance(
                                      pickupLocation, destinationLocation, context);

                                  double price = TripCalculations().calculatePrice(distance, context);
                                  Passenger passenger =
                                  await PStorage.fetchPassengerData();

                                  Trip trip = Trip(
                                      date: DateTime.now().toIso8601String(),
                                      time: TimeOfDay.now().format(context),
                                      FromLocation: pickUpController.text,
                                      ToDestination: destinationController.text,
                                      Status: "Requested",
                                      driver: null,
                                      passenger: passenger,
                                      distance: distance,
                                      price: price);

                                  context.read<TripCubit>().addTrips([trip]);
                                } catch (e) {
                                  MessageDialog().ShowDialog(
                                    context,
                                    title: "Error ❌",
                                    content: "Error sending request.",
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kDarkBlueColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Text(
                                  "Confirm Trip Request",
                                  style: TextStyle(
                                    fontFamily: "Archivo",
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        );
      },
    );
  }

}