import 'package:a5er_elshare3/core/utils/UseCases/FormatDate.dart';
import "package:a5er_elshare3/core/widgets/ThreeDotsLoading.dart";
import 'package:a5er_elshare3/core/utils/Injections/dependency_injection.dart';
import "package:a5er_elshare3/features/Passenger/domain/UseCases/FetchPassengerDataUseCase.dart";
import "package:a5er_elshare3/features/Passenger/presentation/widgets/MessageDialog.dart";
import "package:a5er_elshare3/features/Passenger/presentation/widgets/PlacesSearchField.dart";
import "package:a5er_elshare3/features/Passenger/presentation/widgets/SelectPayment.dart";
import "package:a5er_elshare3/features/Trip/presentation/widgets/PassengerTripCard.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";
import "package:url_launcher/url_launcher.dart";
import '../../../../core/utils/Constants/constants.dart';
import "../../../GoogleMaps/Presentation/cubits/MapsCubit/maps_cubit.dart";
import "../../../Trip/domain/models/trip.dart";
import "../../../Trip/domain/utils/TripCalculations.dart";
import "../../../Trip/presentation/cubits/TripCubit/trip_cubit.dart";
import "../../domain/models/Passenger.dart";
import "InfoRow.dart";
import "TripPriceBox.dart";

class TripDetailsSheet {
  final TextEditingController pickUpController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  Passenger passenger = Passenger();
  Trip trip = Trip();
  double? calculatedPrice = 0.0;

  Future<void> showTripDetailsSheet(BuildContext context) async {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    FetchPassengerDataUseCase fetchPassengerDataUseCase = sl<FetchPassengerDataUseCase>();

    passenger = await fetchPassengerDataUseCase.fetchPassengerData();

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
            initialChildSize: 0.95,
            minChildSize: 0.2,
            maxChildSize: 1.0,
            expand: false,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                child: BlocConsumer<TripCubit, TripState>(
                  listener: (_, state) {
                    // if (state is TripRequestSuccess) {
                    //   MessageDialog().ShowDialog(
                    //     context,
                    //     title: "Success ✅",
                    //     content: state.message,
                    //   );
                    // } else if (state is TripError) {
                    //   MessageDialog().ShowDialog(
                    //     context,
                    //     title: "Error ❌",
                    //     content: state.message,
                    //   );
                    // }
                  },
                  builder: (context, state) {
                    if (state is TripRequested) {
                      return Padding(
                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height - 500.0),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/icon.png",
                                height: 90,
                                width: 90,
                              ),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Searching For a Driver",
                                    style: TextStyle(
                                      color: kDarkBlueColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  ThreeDotsAnimation(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    else if (state is TripAccepted) {
                      final trip = state.trip;
                      final driver = trip.driver;
                      final passenger = trip.passenger;

                      if (driver == null) {
                        return const Center(
                          child: Text("Driver details are unavailable."),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 6,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Driver Information
                                const Text(
                                  "Driver Information",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: kDarkBlueColor,
                                  ),
                                ),
                                const Divider(thickness: 1.5, color: kDarkBlueColor),
                                infoRow("Driver", driver.name),
                                infoRow("Car Model", driver.carModel),
                                infoRow("Car Plate", driver.carPlateNumber),
                                infoRow("Phone", driver.mobileNumber ?? 'N/A'),

                                const SizedBox(height: 20),

                                // Trip Information
                                const Text(
                                  "Trip Details",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: kDarkBlueColor,
                                  ),
                                ),
                                const Divider(thickness: 1.5, color: kDarkBlueColor),
                                infoRow("From", trip.FromLocation),
                                infoRow("To", trip.ToDestination),
                                infoRow("Status", trip.Status),
                                infoRow("Distance", "${trip.distance?.toStringAsFixed(2) ?? 'N/A'} km"),
                                infoRow("Price", "\$${trip.price?.toStringAsFixed(2) ?? 'N/A'}"),
                                infoRow("Payment Method", trip.paymentMethod),

                                const SizedBox(height: 20),

                                // Passenger Information
                                if (passenger != null) ...[
                                  const Text(
                                    "Passenger Information",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: kDarkBlueColor,
                                    ),
                                  ),
                                  const Divider(thickness: 1.5, color: kDarkBlueColor),
                                  infoRow("Passenger", passenger.name),
                                  infoRow("Phone", passenger.mobileNumber ?? 'N/A'),
                                ],

                                const SizedBox(height: 20),

                                // Call Driver Button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      final Uri callUri = Uri(
                                        scheme: 'tel',
                                        path: driver.mobileNumber,
                                      );
                                      if (await canLaunchUrl(callUri)) {
                                        await launchUrl(callUri);
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text("Failed to make a call")),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: kDarkBlueColor,
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    icon: const Icon(Icons.phone, size: 20, color: Colors.white),
                                    label: const Text(
                                      "Call Driver",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
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

                    else if (state is TripStarted) {
                      final trip = state.trip;
                      return Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Trip Started", style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),),
                            const SizedBox(height: 20,),
                            PassengerTripCard(trip: trip,),
                          ],
                        )
                      );
                    }

                    else if (state is TripFinished) {
                      final trip = state.trip;
                      return Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Please Pay", style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                              ),),
                              const SizedBox(height: 10,),
                              Text("\$${trip.price}", style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold
                              ),),
                            ],
                          )
                      );
                    }
                    // else if (state is TripExpired) {
                    //   return Padding(
                    //     padding: EdgeInsets.only(top: MediaQuery.of(context).size.height - 500.0),
                    //     child: Center(
                    //       child: Column(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           Image.asset(
                    //             "assets/images/Hourglass_icon.png",
                    //             height: 90,
                    //             width: 90,
                    //           ),
                    //           const Row(
                    //             mainAxisAlignment: MainAxisAlignment.center,
                    //             children: [
                    //               Text(
                    //                 "Trip Expired",
                    //                 style: TextStyle(
                    //                   color: kDarkBlueColor,
                    //                   fontSize: 20,
                    //                   fontWeight: FontWeight.bold,
                    //                 ),
                    //               ),
                    //               SizedBox(width: 15),
                    //             ],
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   );
                    //
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
                                  TripPrice(price: calculatedPrice!)
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

                                // Show Payment Method Section Only if Both Fields Are Filled
                                if (pickUpController.text.isNotEmpty && destinationController.text.isNotEmpty) ...[
                                  SelectPayment(
                                    onPaymentMethodChanged: (selectedMethod) {
                                      paymentMethod = selectedMethod;
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                ],

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
                                        final currentState = context.read<MapsCubit>().state as MapsLoaded;

                                        final pickupMarker = currentState.markers.firstWhere(
                                              (marker) => marker.markerId == const MarkerId(kPickupId),
                                          orElse: () => throw Exception("Pickup location not set!"),
                                        );

                                        final destinationMarker = currentState.markers.firstWhere(
                                              (marker) => marker.markerId == const MarkerId(kDestinationId),
                                          orElse: () => throw Exception("Destination location not set!"),
                                        );

                                        LatLng pickupLocation = pickupMarker.position;
                                        LatLng destinationLocation = destinationMarker.position;

                                        double distance = TripCalculations().calculateDistance(
                                          pickupLocation,
                                          destinationLocation,
                                          context,
                                        );

                                        double price = TripCalculations().calculatePrice(distance, context);

                                        calculatedPrice = price;

                                        int points = TripCalculations().calculateTripPoints(price, context);
                                        FormattedDate formatter = FormattedDate();
                                        String formattedDate = await formatter.formatToReadable(DateTime.now().toIso8601String());

                                        trip = Trip(
                                          date: formattedDate,
                                          time: TimeOfDay.now().format(context),
                                          FromLocation: pickUpController.text,
                                          ToDestination: destinationController.text,
                                          Status: "Active",
                                          driver: null,
                                          passenger: passenger,
                                          distance: distance,
                                          price: price,
                                          points: points,
                                          paymentMethod: paymentMethod,
                                        );

                                        context.read<TripCubit>().addTrips([trip]);
                                      } catch (e) {
                                        MessageDialog().ShowDialog(
                                          context,
                                          title: "Error ❌",
                                          content: "Failed to create trip: ${e.toString()}",
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
                ),
              );
            },
          ),
        );
      },
    );
  }
}

