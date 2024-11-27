import 'package:a5er_elshare3/core/validators/validators.dart';
import 'package:a5er_elshare3/core/widgets/MapsView.dart';
import 'package:a5er_elshare3/features/Authentication/data/Database/FirebaseAuthentication.dart';
import 'package:a5er_elshare3/features/Passenger/data/Database/PassengerStorage.dart';
import 'package:a5er_elshare3/features/Passenger/data/models/Passenger.dart';
import 'package:a5er_elshare3/features/Welcome/presentation/screens/Opening.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_maps_webservices/places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geocoding/geocoding.dart' as geocoding; // Alias for geocoding package
import 'package:google_places_flutter_api/google_places_flutter_api.dart';
import "../../../../core/utils/constants.dart";

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
  Set<Marker> _markers = {};
  LatLng? _currentLocation;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  PassengerStorage _storage = PassengerStorage();


  void _addMarker(LatLng position, String title) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(position.toString()),
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
        _currentLocation = newLocation;

        // Add a marker using _addMarker
        _addMarker(newLocation, locationName);

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
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                // Perform validation or trip confirmation logic here
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
                                    fontWeight: FontWeight.bold),
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

  Widget _buildPlaceSearchField(String hint, IconData icon, {required bool isPickup}) {
    return GestureDetector(
      onTap: () async {
        Prediction? prediction = await PlacesAutocomplete.show(
          context: context,
          apiKey: "AIzaSyDoBHEaV4zb2EsvqDqiIfaFq9h5nTw3Qk8", // The Places API key is still required for the autocomplete
          mode: Mode.overlay,
          language: "en",
        );

        if (prediction != null) {
          try {
            // Use geocoding to get the latitude and longitude based on the address
            List<geocoding.Location> locations = await locationFromAddress(prediction.description ?? "");

            if (locations.isNotEmpty) {
              geocoding.Location location = locations.first;
              LatLng latLng = LatLng(location.latitude, location.longitude);

              // Add marker on map
              _addMarker(latLng, prediction.description ?? "");

              // Update the appropriate controller (pickup or destination)
              if (isPickup) {
                pickUpController.text = prediction.description ?? "";
              } else {
                destinationController.text = prediction.description ?? "";
              }
            }
          } catch (e) {
            // Handle error if geocoding fails
            print("Geocoding error: $e");
          }
        }
      },
      child: Column(
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
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kDarkBlueColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
              ),
              onPressed: () =>
                  _getCurrentLocation(isPickup: isPickup),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.gps_fixed_sharp,
                        color: Colors.white),
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
          ),
        ],
      ),
    );
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
              return const Center(child: CircularProgressIndicator(
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
                            style: TextStyle(
                                fontSize: 18,
                                overflow: TextOverflow.visible,
                                color: kDarkBlueColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${passenger.email ?? "passenger@email.com"}",
                            style: TextStyle(
                              fontSize: 14,
                              overflow: TextOverflow.visible,
                              color: kDarkBlueColor,
                            ),
                          ),
                          Text(
                            "${passenger.mobileNumber ?? "01234567890"}",
                            style: TextStyle(
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
                      Navigator.pop(context);
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
                    onTap: () async{
                      await authentication.SignOut();
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Opening()));
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
