import 'package:a5er_elshare3/features/Authentication/data/Database/FirebaseAuthentication.dart';
import 'package:a5er_elshare3/features/Driver/presentation/screens/DriverHome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../Passenger/presentation/screens/PassengerHome.dart';
import 'Opening.dart'; // Fallback if no user is signed in

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  Authentication authentication = Authentication();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    // Create an AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000), // Animation duration
    );

    // Create an Animation
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut, // Animation curve
    );

    // Start the animation and check user role
    _controller.forward().then((_) => _navigateToHome());
  }

  Future<void> _navigateToHome() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        // Fetch user role from Firestore (Passengers or Drivers collections)
        String? role = await authentication.fetchUserRole(user.uid);

        if (role == 'Passenger') {
          // Navigate to Passenger Home
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const PassengerHome()),
          );
        } else if (role == 'Driver') {
          // Navigate to Driver Home
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const DriverHome()),
          );
        } else {
          // Navigate to Opening if the role is not defined
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const Opening()),
          );
        }
      } catch (e) {
        // Handle Firestore or other errors
        print("Error navigating to home: $e");
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const Opening()),
        );
      }
    } else {
      // Navigate to Opening if no user is signed in
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const Opening()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Center(
          child: FadeTransition(
            opacity: _animation,
            child: Image.asset(
              "assets/images/default.png",
              width: MediaQuery.of(context).size.width * 0.6, // Constrain width
              height:
              MediaQuery.of(context).size.height * 0.4, // Constrain height
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
