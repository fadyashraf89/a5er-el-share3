import 'dart:math';
import 'package:a5er_elshare3/core/validators/validators.dart';
import 'package:a5er_elshare3/core/widgets/MapsView.dart';
import 'package:a5er_elshare3/features/Authentication/data/Database/FirebaseAuthentication.dart';
import 'package:a5er_elshare3/features/Passenger/data/Database/PassengerStorage.dart';
import 'package:a5er_elshare3/features/Passenger/data/models/Passenger.dart';
import 'package:a5er_elshare3/features/Trip/data/Database/TripStorage.dart';
import 'package:a5er_elshare3/features/Trip/presentation/screens/TripList.dart';
import 'package:a5er_elshare3/features/Welcome/presentation/screens/Opening.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_maps_webservices/places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:google_places_flutter_api/google_places_flutter_api.dart';
import "../../../../core/utils/constants.dart";
import '../../../Trip/data/models/trip.dart';

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
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  LatLng? _currentLocation;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final PassengerStorage _storage = PassengerStorage();
  final TripStorage TStorage = TripStorage();

  void _addMarker(LatLng position, String title, MarkerId markerId) {
    setState(() {
      // Remove any existing marker with the same ID (optional)
      _markers.removeWhere((marker) => marker.markerId == markerId);

      _markers.add(
        Marker(
          markerId: markerId,
          position: position,
          infoWindow: InfoWindow(title: title),
        ),
      );
    });
  }

  Future<void> _getCurrentLocation({bool isPickup = true}) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled.')),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied.')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Location permissions are permanently denied.')),
      );
      return;
    }

    try {
      // Get the current position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      LatLng newLocation = LatLng(position.latitude, position.longitude);

      // Reverse geocode to get the location name
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      String locationName = placemarks.isNotEmpty
          ? "${placemarks.first.street}, ${placemarks.first.locality}"
          : "Unknown Location";

      setState(() {
        // Remove any existing marker for pickup or destination based on isPickup
        _markers.removeWhere((marker) =>
            (marker.markerId == const MarkerId('pickup') && isPickup) ||
            (marker.markerId == const MarkerId('destination') && !isPickup));

        _currentLocation = newLocation;

        // Add a marker using _addMarker with the appropriate MarkerId
        MarkerId markerId =
            isPickup ? const MarkerId('pickup') : const MarkerId('destination');
        _addMarker(newLocation, locationName, markerId);

        // Update the map camera
        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(newLocation, 16.0),
        );

        // Update the text field based on the parameter
        if (isPickup) {
          pickUpController.text = locationName;
        } else {
          destinationController.text = locationName;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get location: $e')),
      );
    }
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
          child: DraggableScrollableSheet(
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
                        // Pickup Location
                        _buildPlaceSearchField(
                          "Enter Pick-Up Point",
                          Icons.pin_drop,
                          isPickup: true,
                        ),
                        const SizedBox(height: 15),
                        // Destination
                        _buildPlaceSearchField(
                          "Enter Destination",
                          Icons.map_outlined,
                          isPickup: false,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              // Form validation
                              if (pickUpController.text.isEmpty ||
                                  destinationController.text.isEmpty) {
                                _showDialog(
                                  context,
                                  title: "Error ❌",
                                  content: "Both fields are required.",
                                );
                                return;
                              }

                              if (pickUpController.text == destinationController.text) {
                                _showDialog(
                                  context,
                                  title: "Error ❌",
                                  content: "Pickup and Destination cannot be the same.",
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

                              // Firebase logic
                              try {
                                LatLng pickupLocation = _markers
                                    .firstWhere((marker) => marker.markerId == const MarkerId('pickup'))
                                    .position;
                                LatLng destinationLocation = _markers
                                    .firstWhere((marker) => marker.markerId == const MarkerId('destination'))
                                    .position;

                                double distance = calculateDistance(pickupLocation, destinationLocation);
                                Passenger passenger = await _storage.fetchPassengerData();

                                Trip trip = Trip(
                                  date: DateTime.now().toIso8601String(),
                                  time: TimeOfDay.now().format(context),
                                  FromLocation: pickUpController.text,
                                  ToDestination: destinationController.text,
                                  Status: "Requested ⌛",
                                  driver: null,
                                  passenger: passenger,
                                  distance: distance,
                                );

                                await TStorage.addTrip([trip]);

                                _showDialog(
                                  context,
                                  title: "Success ✅",
                                  content: "Request has been sent successfully.",
                                );
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
          ),
        );
      },
    );
  }

  void _showDialog(BuildContext context, {required String title, required String content}) {
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

  Widget _buildPlaceSearchField(String hint, IconData icon,
      {required bool isPickup}) {
    bool locationSelected = false;
    return GestureDetector(
      onTap: () async {
        Prediction? prediction = await PlacesAutocomplete.show(
          context: context,
          apiKey: "AIzaSyDoBHEaV4zb2EsvqDqiIfaFq9h5nTw3Qk8",
          mode: Mode.fullscreen,
          language: "en",
        );

        if (prediction != null) {
          try {
            // Use geocoding to get the latitude and longitude based on the address
            List<geocoding.Location> locations =
                await locationFromAddress(prediction.description ?? "");
            String? locationName = prediction.description;

            if (locations.isNotEmpty) {
              geocoding.Location location = locations.first;
              LatLng latLng = LatLng(location.latitude, location.longitude);

              setState(() {
                if (locationSelected) {
                  _markers.removeWhere((marker) =>
                      (marker.markerId == const MarkerId('pickup') && isPickup) ||
                      (marker.markerId == const MarkerId('destination') &&
                          !isPickup));
                }

                // Add a marker for the selected location
                MarkerId markerId =
                    isPickup ? const MarkerId('pickup') : const MarkerId('destination');
                _addMarker(latLng, locationName!, markerId);

                // Update the map camera to include both markers
                LatLngBounds bounds = LatLngBounds(
                  southwest: LatLng(
                    min(_currentLocation?.latitude ?? latLng.latitude,
                        latLng.latitude),
                    min(_currentLocation?.longitude ?? latLng.longitude,
                        latLng.longitude),
                  ),
                  northeast: LatLng(
                    max(_currentLocation?.latitude ?? latLng.latitude,
                        latLng.latitude),
                    max(_currentLocation?.longitude ?? latLng.longitude,
                        latLng.longitude),
                  ),
                );
                _mapController
                    ?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 10.0));

                // Update the appropriate controller (pickup or destination)
                if (isPickup) {
                  pickUpController.text = prediction.description ?? "";
                } else {
                  destinationController.text = prediction.description ?? "";
                }

                locationSelected = true;
              });
            }
          } catch (e) {
            // Handle error if geocoding fails
            print("Geocoding error: $e");
          }
        }
      },
      child: Stack(children: [
        Column(
          children: [
            AbsorbPointer(
              child: TextFormField(
                controller: isPickup ? pickUpController : destinationController,
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: const TextStyle(fontFamily: "Archivo"),
                  prefixIcon: Icon(icon),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '$hint is required';
                  }
                  return null;
                },
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kDarkBlueColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
              ),
              onPressed: () => _getCurrentLocation(isPickup: isPickup),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.gps_fixed_sharp, color: Colors.white),
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
            ),
          ],
        ),
      ]),
    );
  }

  double calculateDistance(LatLng point1, LatLng point2) {
    double distanceInMeters = Geolocator.distanceBetween(
      point1.latitude,
      point1.longitude,
      point2.latitude,
      point2.longitude,
    );

    double distanceInKilometers = distanceInMeters / 1000;

    return distanceInKilometers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: kDarkBlueColor,
        width: 250,
        child: FutureBuilder<Passenger>(
          future: _storage.fetchPassengerData(),
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
                            "Welcome, ${passenger.name ?? "Passenger"}",
                            style: const TextStyle(
                                fontSize: 18,
                                overflow: TextOverflow.visible,
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const TripList()));
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
                      Navigator.pop(context);
                      // Navigate to Profile
                    },
                  ),
                  const Center(
                      child: Divider(
                    height: 20,
                    thickness: 2,
                    color: Colors.grey,
                  )),
                  ListTile(
                    leading: const Icon(Icons.settings, color: Colors.white),
                    title: const Text("Settings",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to Settings
                    },
                  ),
                  const Center(
                      child: Divider(
                    height: 20,
                    thickness: 2,
                    color: Colors.grey,
                  )),
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
          MapsView(
            onMapCreated: (controller) {
              _mapController = controller;
            },
            currentLocation: _currentLocation,
            markers: _markers,
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
            bottom: 16,
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
