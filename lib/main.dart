import 'package:a5er_elshare3/features/Driver/presentation/screens/DriverHome.dart';
import 'package:a5er_elshare3/features/Passenger/presentation/screens/PassengerHome.dart';
import 'package:a5er_elshare3/features/Welcome/presentation/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures binding is initialized before Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Archivo', // The font family declared in pubspec.yaml
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
