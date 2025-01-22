import "package:a5er_elshare3/core/utils/FormatedDate.dart";
import "package:a5er_elshare3/core/widgets/ThreeDotsLoading.dart";
import "package:a5er_elshare3/features/Passenger/presentation/widgets/MessageDialog.dart";
import "package:a5er_elshare3/features/Passenger/presentation/widgets/PlacesSearchField.dart";
import "package:a5er_elshare3/features/Passenger/presentation/widgets/SelectPayment.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";
import "../../../../core/utils/constants.dart";
import "../../../GoogleMaps/Presentation/cubits/MapsCubit/maps_cubit.dart";
import "../../../Trip/domain/models/trip.dart";
import "../../../Trip/domain/utils/TripCalculations.dart";
import "../../../Trip/presentation/cubits/TripCubit/trip_cubit.dart";
import "../../data/Database/FirebasePassengerStorage.dart";
import "../../domain/models/Passenger.dart";
import "TripPriceBox.dart";

class TripDetailsSheet {
  final TextEditingController pickUpController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final FirebasePassengerStorage PStorage = FirebasePassengerStorage();

  Passenger passenger = Passenger();

  Trip trip = Trip();
  double? calculatedPrice = 0.0;

  Future<void> showTripDetailsSheet(BuildContext context) async {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    passenger = await PStorage.fetchPassengerData();

    String? paymentMethod = 'Cash';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: DraggableScrollableSheet(
            initialChildSize: 0.9,
            minChildSize: 0.2,
            expand: false,
            builder: (context, scrollController) {
              return BlocConsumer<TripCubit, TripState>(
                listener: (_, state) {
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
                },
                builder: (context, state) {
                  if (state is TripRequested){
                    return Center(
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [Image.asset("assets/images/icon.png", height: 90, width: 90),
                           const Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               Text(
                                 "Searching For a Driver",
                                 style: TextStyle(
                                   color: kDarkBlueColor,
                                   fontSize: 20,
                                   fontWeight: FontWeight.bold
                                 ),
                               ),
                               SizedBox(width: 15,),

                               ThreeDotsAnimation(),

                             ],
                           ),
                           // TimerWidget(expiryDuration: state.expiryDuration)
                         ],
                       )
                    );
                  }
                  // else if (state is TripAccepted) {
                  //   final driver = state.trip.driver; // Assuming TripAccepted includes the trip with a driver.
                  //
                  //   if (driver == null) {
                  //     return Center(
                  //       child: Text("Driver details are unavailable."),
                  //     );
                  //   }
                  //
                  //   return Padding(
                  //     padding: const EdgeInsets.all(16.0),
                  //     child: Card(
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(15),
                  //       ),
                  //       elevation: 4,
                  //       child: Padding(
                  //         padding: const EdgeInsets.all(16.0),
                  //         child: Column(
                  //           mainAxisSize: MainAxisSize.min,
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Row(
                  //               children: [
                  //                 CircleAvatar(
                  //                   radius: 30,
                  //                   backgroundColor: Colors.grey[200],
                  //                   child: Icon(Icons.person, size: 30, color: Colors.grey),
                  //                 ),
                  //                 const SizedBox(width: 16),
                  //                 Column(
                  //                   crossAxisAlignment: CrossAxisAlignment.start,
                  //                   children: [
                  //                     Text(
                  //                       "Driver: ${driver.name}",
                  //                       style: const TextStyle(
                  //                         fontSize: 18,
                  //                         fontWeight: FontWeight.bold,
                  //                       ),
                  //                     ),
                  //                     const SizedBox(height: 4),
                  //                     Text(
                  //                       "Car Model: ${driver.carModel}",
                  //                       style: const TextStyle(fontSize: 16, color: Colors.grey),
                  //                     ),
                  //                     const SizedBox(height: 4),
                  //                     Text(
                  //                       "Car Plate: ${driver.carPlateNumber}",
                  //                       style: const TextStyle(fontSize: 16, color: Colors.grey),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ],
                  //             ),
                  //             const SizedBox(height: 20),
                  //             SizedBox(
                  //               width: double.infinity,
                  //               child: ElevatedButton.icon(
                  //                 onPressed: () async {
                  //                   // Use a package like `url_launcher` to initiate a call.
                  //                   final Uri callUri = Uri(
                  //                     scheme: 'tel',
                  //                     path: driver.mobileNumber,
                  //                   );
                  //                   if (await canLaunchUrl(callUri)) {
                  //                     await launchUrl(callUri);
                  //                   } else {
                  //                     // Handle error if call can't be made.
                  //                     ScaffoldMessenger.of(context).showSnackBar(
                  //                       const SnackBar(content: Text("Failed to make a call")),
                  //                     );
                  //                   }
                  //                 },
                  //                 style: ElevatedButton.styleFrom(
                  //                   backgroundColor: Colors.green,
                  //                   padding: const EdgeInsets.symmetric(vertical: 12),
                  //                   shape: RoundedRectangleBorder(
                  //                     borderRadius: BorderRadius.circular(10),
                  //                   ),
                  //                 ),
                  //                 icon: const Icon(Icons.phone, size: 20, color: Colors.white),
                  //                 label: const Text(
                  //                   "Call Driver",
                  //                   style: TextStyle(
                  //                     fontSize: 16,
                  //                     color: Colors.white,
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   );
                  // }


                  else {
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
                                  fontFamily: kFontFamilyArchivo,
                                  color: kDarkBlueColor,
                                ),
                              ),
                              const SizedBox(height: 10),
                              if (calculatedPrice != null)
                                TripPrice(price: calculatedPrice)
                              else
                                const SizedBox.shrink(),
                              const SizedBox(height: 20),
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
                              const Text(
                                "Select Payment Method",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  fontFamily: kFontFamilyArchivo,
                                  color: kDarkBlueColor,
                                ),
                              ),
                              SelectPayment(
                                onPaymentMethodChanged: (selectedMethod) async {
                                  paymentMethod = selectedMethod;
                                  try {
                                    SelectPaymentMethod(
                                        selectedMethod, passenger, trip);
                                  } catch (e) {
                                    MessageDialog().ShowDialog(
                                      context,
                                      title: "Error ❌",
                                      content:
                                      "An error occurred: ${e.toString()}",
                                    );
                                  }
                                  final currentState = context
                                      .read<MapsCubit>()
                                      .state as MapsLoaded;

                                  final pickupMarker =
                                  currentState.markers.firstWhere(
                                        (marker) =>
                                    marker.markerId ==
                                        const MarkerId(kPickupId),
                                    orElse: () => throw Exception(
                                        "Pickup location not set!"),
                                  );

                                  final destinationMarker =
                                  currentState.markers.firstWhere(
                                        (marker) =>
                                    marker.markerId ==
                                        const MarkerId(kDestinationId),
                                    orElse: () => throw Exception(
                                        "Destination location not set!"),
                                  );

                                  LatLng pickupLocation = pickupMarker.position;
                                  LatLng destinationLocation =
                                      destinationMarker.position;

                                  double distance =
                                  TripCalculations().calculateDistance(
                                    pickupLocation,
                                    destinationLocation,
                                    context,
                                  );

                                  double price = TripCalculations()
                                      .calculatePrice(distance, context);

                                  calculatedPrice = price;

                                  int points = TripCalculations()
                                      .calculateTripPoints(price, context);
                                  FormattedDate formatter = FormattedDate();
                                  String formattedDate = await formatter.formatToReadable(DateTime.now().toIso8601String());  // Await the result

                                  trip = Trip(
                                    date: formattedDate,
                                    time: TimeOfDay.now().format(context),
                                    FromLocation: pickUpController.text,
                                    ToDestination: destinationController.text,
                                    Status: "Requested",
                                    driver: null,
                                    passenger: passenger,
                                    distance: distance,
                                    price: price,
                                    points: points,
                                    paymentMethod: paymentMethod,
                                  );
                                },
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
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

                                    try {
                                      context.read<TripCubit>().addTrips([trip]);
                                    } catch (e) {
                                      MessageDialog().ShowDialog(
                                        context,
                                        title: "Error ❌",
                                        content: "Failed to create trip.",
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
                                        fontFamily: kFontFamilyArchivo,
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
                  }
                },
              );
            },
          ),
        );
      },
    );
  }
}
