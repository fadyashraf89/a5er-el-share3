import 'package:a5er_elshare3/screens/authentication/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

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
      parent: _controller, curve: Curves.easeInOut, // Animation curve
    );

    // Start the animation
    _controller.forward().then((_) {
      // Navigate after animation completes
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const SignInPage()),
      );
    });
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
              height: MediaQuery.of(context).size.height * 0.4, // Constrain height
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

}
