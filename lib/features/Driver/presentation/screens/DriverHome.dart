import "package:a5er_elshare3/features/Trip/presentation/screens/DriverTripList.dart";
import "package:flutter/material.dart";

import "../../../../core/utils/constants.dart";
import "../../../AuthService/data/Database/FirebaseAuthentication.dart";
import "../../../Trip/data/Database/FirebaseTripStorage.dart";
import "../../data/database/FirebaseDriverStorage.dart";
import "../../domain/models/driver.dart";
import "../widgets/DriverDrawer.dart";

class DriverHome extends StatefulWidget {
  const DriverHome({super.key});

  @override
  State<DriverHome> createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> {
  final FirebaseDriverStorage DStorage = FirebaseDriverStorage();
  final FirebaseTripStorage TStorage = FirebaseTripStorage();
  Driver driver = Driver();
  AuthService authentication = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DriverDrawer().OpenDrawer(),
      body: Stack(
        children: [
          Container(child: DriverTripList(driver: driver)),
          // Pass driver to DriverTripList
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
