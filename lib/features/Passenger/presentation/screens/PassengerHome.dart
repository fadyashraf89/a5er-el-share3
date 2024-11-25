import 'package:a5er_elshare3/core/widgets/MapsView.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import "../../../../core/utils/constants.dart";

class PassengerHome extends StatefulWidget {
  const PassengerHome({Key? key}) : super(key: key);

  @override
  State<PassengerHome> createState() => _PassengerHomeState();
}

class _PassengerHomeState extends State<PassengerHome> {
  final TextEditingController pickUpController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  Future<void> _getCurrentLocation(TextEditingController controller) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled.')),
      );
      return;
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied.')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Location permissions are permanently denied, we cannot request permissions.')),
      );
      return;
    }

    // Fetch the current location
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Update the controller with the location
      controller.text =
          "${position.latitude}, ${position.longitude}";
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get location: $e')),
      );
    }
  }

  void _showTripDetailsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      // Allows the bottom sheet to be resizable
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.2,
          maxChildSize: 0.8,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
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
                    // Add some spacing between the widgets
                    Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: pickUpController,
                              decoration: InputDecoration(
                                hintText: 'Enter Pick-Up Point',
                                hintStyle:
                                    const TextStyle(fontFamily: "Archivo"),
                                prefixIcon: const Icon(Icons.pin_drop),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(
                                        20), // Top corners rounded
                                  ),
                                  borderSide:
                                      const BorderSide(color: kDarkBlueColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                  borderSide: const BorderSide(
                                      color: kDarkBlueColor, width: 2),
                                ),
                              ),
                            ),
                            SizedBox(height: 45),
                            // Height of the button to leave space in the column
                          ],
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kDarkBlueColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(
                                      20), // Bottom corners rounded
                                ),
                              ),
                            ),
                            onPressed: () =>
                                _getCurrentLocation(pickUpController),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.gps_fixed_sharp,
                                      color: Colors.white),
                                  const SizedBox(width: 8),
                                  // Space between icon and text
                                  const Text(
                                    "From Your Current Location",
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
                    const SizedBox(height: 15),
                    Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: destinationController,
                              decoration: InputDecoration(
                                hintText: 'Enter Destination',
                                hintStyle:
                                    const TextStyle(fontFamily: "Archivo"),
                                prefixIcon: const Icon(Icons.map_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(
                                        20), // Top corners rounded
                                  ),
                                  borderSide:
                                      const BorderSide(color: kDarkBlueColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                  borderSide: const BorderSide(
                                      color: kDarkBlueColor, width: 2),
                                ),
                              ),
                            ),
                            SizedBox(height: 45),
                            // Height of the button to leave space in the column
                          ],
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kDarkBlueColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(
                                      20), // Bottom corners rounded
                                ),
                              ),
                            ),
                            onPressed: () =>
                                _getCurrentLocation(destinationController),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.gps_fixed_sharp,
                                      color: Colors.white),
                                  const SizedBox(width: 8),
                                  // Space between icon and text
                                  const Text(
                                    "To Your Current Location",
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
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          CheckSamePickUpAndDestination(pickUpController, destinationController);
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
                            "Confirm Trip",
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
            );
          },
        );
      },
    );
  }

  void CheckSamePickUpAndDestination(TextEditingController pickupController,TextEditingController destinationController){
    if(pickUpController.text == destinationController.text){
      ShowMessageDialog();
    }
  }

  Future<void> ShowMessageDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          icon: Icon(
            Icons.error_outlined,
            color: Colors.red,
            size: 30,
          ),
          title: const Text('Error'),
          content: const SingleChildScrollView(
            child: Center(child: Text("Pick up point and destination can't be the same!")),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        elevation: 0,
        width: 250,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            // Align items in the center
            crossAxisAlignment: CrossAxisAlignment.start,
            // Align items to the left
            children: [
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text("Home"),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to Home
                },
              ),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text("Trip History"),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to Trip History
                },
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text("Profile"),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to Profile
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text("Settings"),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to Settings
                },
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          MapsView(),
          Positioned(
            top: 40,
            right: 16,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 24,
              child: Builder(
                builder: (innerContext) => IconButton(
                  icon: const Icon(Icons.menu, color: kDarkBlueColor),
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
                  "View Trip Details",
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
