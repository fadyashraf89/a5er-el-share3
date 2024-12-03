import "package:a5er_elshare3/features/Driver/data/database/DriverStorage.dart";
import "package:a5er_elshare3/features/Driver/data/models/driver.dart";
import "package:a5er_elshare3/features/Trip/presentation/screens/DriverTripList.dart";
import "package:flutter/material.dart";

import "../../../../core/utils/constants.dart";
import "../../../Authentication/data/Database/FirebaseAuthentication.dart";
import "../../../Trip/data/Database/TripStorage.dart";
import "../../../Welcome/presentation/screens/Opening.dart";

class DriverHome extends StatefulWidget {
  const DriverHome({super.key});

  @override
  State<DriverHome> createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> {
  final DriverStorage DStorage = DriverStorage();
  final TripStorage TStorage = TripStorage();
  Driver driver = Driver();
  Authentication authentication = Authentication();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: kDarkBlueColor,
        width: 250,
        child: FutureBuilder<Driver>(
          future: DStorage.fetchDriverData(),
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

            final driver = snapshot.data!;
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
                            "Welcome, ${driver.name ?? "Driver"}",
                            style: const TextStyle(
                                fontSize: 18,
                                overflow: TextOverflow.visible,
                                color: kDarkBlueColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            driver.email ?? "Driver@email.com",
                            style: const TextStyle(
                              fontSize: 14,
                              overflow: TextOverflow.visible,
                              color: kDarkBlueColor,
                            ),
                          ),
                          Text(
                            driver.mobileNumber ?? "01234567890",
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
          Container(child: DriverTripList(driver: driver)), // Pass driver to DriverTripList
          Positioned(
            bottom: 20,
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
        ],
      ),
    );
  }
}
