import 'package:a5er_elshare3/core/validators/validators.dart';
import 'package:a5er_elshare3/features/Authentication/data/Database/FirebaseAuthentication.dart';
import 'package:a5er_elshare3/features/Passenger/presentation/widgets/TripDetailsSheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import "../../../../core/utils/constants.dart";
import '../../../GoogleMaps/Presentation/cubits/MapsCubit/maps_cubit.dart';
import '../../../GoogleMaps/Presentation/screens/MapsView.dart';
import '../../../Trip/data/Database/FirebaseTripStorage.dart';
import '../../data/Database/FirebasePassengerStorage.dart';
import "../widgets/PassengerDrawer.dart";

class PassengerHome extends StatefulWidget {
  const PassengerHome({super.key});

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
  final FirebaseTripStorage TStorage = FirebaseTripStorage();
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: PassengerDrawer().OpenDrawer(),
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
              onPressed: () => TripDetailsSheet().showTripDetailsSheet(context),
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
