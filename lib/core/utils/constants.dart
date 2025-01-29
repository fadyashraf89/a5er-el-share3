import 'dart:ui';

import 'package:flutter_dotenv/flutter_dotenv.dart';

const kDarkBlueColor = Color(0xff1d198b);
const kPickupId = "pickup";
const kDestinationId = "destination";
String apiKey = dotenv.env['API_KEY']!;
const kDriversCollection = "Drivers";
const kPassengersCollection = "Passengers";
const kFontFamilyArchivo = "Archivo";
const kAppLogo = "assets/images/default.png";
const kCardsCollection = "Cards";
const kTripHistoryCollection = "History";
const kAcceptedTripsCollection = "AcceptedTrips";
const kRejectedTripsCollection = "Rejected Trips";
const kTripsCollection = "Trips";
const kActiveTripsCollection = "Active Trips";
const kExpiredTripsCollection = "Expired Trips";
