import 'package:a5er_elshare3/core/validators/validators.dart';
import 'package:a5er_elshare3/features/Authentication/data/Database/FirebaseAuthentication.dart';
import 'package:a5er_elshare3/features/Passenger/presentation/screens/PassengerProfile.dart';
import 'package:a5er_elshare3/features/Trip/data/Database/TripStorage.dart';
import 'package:a5er_elshare3/features/Trip/presentation/cubits/TripCubit/trip_cubit.dart';
import 'package:a5er_elshare3/features/Trip/presentation/screens/PassengerTripList.dart';
import 'package:a5er_elshare3/features/Welcome/presentation/screens/Opening.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_google_maps_webservices/places.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter_api/google_places_flutter_api.dart';
import "../../../../core/utils/constants.dart";
import '../../../GoogleMaps/Presentation/cubits/MapsCubit/maps_cubit.dart';
import '../../../GoogleMaps/Presentation/screens/MapsView.dart';
import '../../../Trip/domain/models/trip.dart';
import '../../data/Database/FirebasePassengerStorage.dart';
import '../../domain/models/Passenger.dart';
import '../cubits/PassengerCubit/passenger_cubit.dart';

class PassengerHome extends StatefulWidget {
  const PassengerHome({Key? key}) : super(key: key);

  @override
  State<PassengerHome> createState() => _PassengerHomeState();
}

class _PassengerHomeState extends State<PassengerHome> {
  final TextEditingController pickUpController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  Validators validators = Validators();
  Authentication authentication = Authentication();
  final formKey = GlobalKey<FormState>();
  final Set<Marker> _markers = {};
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebasePassengerStorage PStorage = FirebasePassengerStorage();
  final TripStorage TStorage = TripStorage();
  @override
  void dispose() {
    super.dispose();
  }

  void _showTripDetailsSheet(BuildContext context) {
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
              _showDialog(
                context,
                title: "Success ✅",
                content: state.message,
              );
            } else if (state is TripError) {
              _showDialog(
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
                          _buildPlaceSearchField(
                            "Enter Pick-Up Point",
                            Icons.pin_drop,
                            pickUpController,
                            context,
                            isPickup: true,
                          ),
                          const SizedBox(height: 15),
                          _buildPlaceSearchField(
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
                                  _showDialog(
                                    context,
                                    title: "Error ❌",
                                    content: "Both fields are required.",
                                  );
                                  return;
                                }

                                if (pickUpController.text ==
                                    destinationController.text) {
                                  _showDialog(
                                    context,
                                    title: "Error ❌",
                                    content:
                                        "Pickup and Destination cannot be the same.",
                                  );
                                  return;
                                }

                                if (!formKey.currentState!.validate()) {
                                  _showDialog(
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

                                  double distance = calculateDistance(
                                      pickupLocation, destinationLocation);

                                  double price = calculatePrice(distance);
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
                                  _showDialog(
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

  void _showDialog(BuildContext context,
      {required String title, required String content}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(child: Text(title)),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceSearchField(
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

  double calculateDistance(LatLng point1, LatLng point2) {
    double distanceInKilometers =
        context.read<TripCubit>().calculateDistance(point1, point2);

    return distanceInKilometers;
  }

  double calculatePrice(double distanceInKilometers) {
    double price = context.read<TripCubit>().calculatePrice(distanceInKilometers);
    return price;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: kDarkBlueColor,
        width: 250,
        child: FutureBuilder<Passenger>(
          future: PStorage.fetchPassengerData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.white,
              ));
            }
            if (snapshot.hasError) {
              return const Center(child: Text("Error loading user data"));
            }

            final passenger = snapshot.data!;
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.white,
                    height: 300,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/default.png",
                            width: 120,
                            height: 120,
                          ),
                          Text(
                            overflow: TextOverflow.visible,
                            textAlign: TextAlign.center,
                            "Welcome, ${passenger.name ?? "Passenger"}",
                            style: const TextStyle(
                                fontSize: 18,
                                color: kDarkBlueColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            passenger.email ?? "passenger@email.com",
                            style: const TextStyle(
                              fontSize: 14,
                              overflow: TextOverflow.visible,
                              color: kDarkBlueColor,
                            ),
                          ),
                          Text(
                            passenger.mobileNumber ?? "01234567890",
                            style: const TextStyle(
                              fontSize: 14,
                              overflow: TextOverflow.visible,
                              color: kDarkBlueColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    leading: const Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                    title: const Text(
                      "Home",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to Home
                    },
                  ),
                  const Center(
                      child: Divider(
                    height: 20,
                    thickness: 2,
                    color: Colors.grey,
                  )),
                  ListTile(
                    leading: const Icon(
                      Icons.history,
                      color: Colors.white,
                    ),
                    title: const Text("Trip History",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PassengerTripList()));
                      // Navigate to Trip History
                    },
                  ),
                  const Center(
                      child: Divider(
                    height: 20,
                    thickness: 2,
                    color: Colors.grey,
                  )),
                  ListTile(
                    leading: const Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    title: const Text("Profile",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider(
                            create: (context) =>
                                PassengerCubit(FirebasePassengerStorage()),
                            child: const PassengerProfile(),
                          ),
                        ),
                      );
                      // Navigate to Profile
                    },
                  ),
                  const Center(
                      child: Divider(
                    height: 20,
                    thickness: 2,
                    color: Colors.grey,
                  )),
                  // ListTile(
                  //   leading: const Icon(Icons.settings, color: Colors.white),
                  //   title: const Text("Settings",
                  //       style: TextStyle(
                  //           color: Colors.white, fontWeight: FontWeight.bold)),
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //     // Navigate to Settings
                  //   },
                  // ),
                  // const Center(
                  //     child: Divider(
                  //   height: 20,
                  //   thickness: 2,
                  //   color: Colors.grey,
                  // )),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.white),
                    title: const Text("Log Out",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    onTap: () async {
                      await authentication.SignOut();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Opening()));
                      // Navigate to Settings
                    },
                  ),
                  const Center(
                      child: Divider(
                    height: 20,
                    thickness: 2,
                    color: Colors.grey,
                  )),
                ],
              ),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          BlocConsumer<MapsCubit, MapsState>(
            listener: (context, state) {
              if (state is MapsError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              print("Current MapsCubit state: $state");
              if (state is MapsLoaded) {
                return MapsView(
                  onMapCreated: (GoogleMapController controller) {
                    context.read<MapsCubit>().setMapController(controller);
                  },
                  currentLocation: state.currentLocation,
                  markers: _markers,
                );
              }
              if (state is MapsError) {
                return Center(child: Text(state.message));
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
          Positioned(
            top: 40,
            right: 16,
            child: CircleAvatar(
              backgroundColor: kDarkBlueColor,
              radius: 24,
              child: Builder(
                builder: (innerContext) => IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () => Scaffold.of(innerContext).openDrawer(),
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height - 120,
            left: 16,
            right: 16,
            child: ElevatedButton(
              // onPressed: _getCurrentLocation,
              onPressed: () => _showTripDetailsSheet(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: kDarkBlueColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  "Request a Trip",
                  style: TextStyle(
                      fontFamily: "Archivo",
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
