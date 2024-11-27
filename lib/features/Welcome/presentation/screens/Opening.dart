import 'package:flutter/material.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/RoundedAppBar.dart';
import '../../../Authentication/presentation/screens/login.dart';
import '../../../Authentication/presentation/screens/signup.dart';

class Opening extends StatefulWidget {
  const Opening({super.key});

  @override
  State<Opening> createState() => _OpeningState();
}

class _OpeningState extends State<Opening> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBlueColor,
      body: Stack(
        children: [
          // AppBar with Rounded Shape
          const RoundedAppBar(
            height: 750,
            color: Colors.white,
          ),
          // Buttons
          Positioned(
            top: 150, // Adjust position relative to the AppBar height
            left: 30,
            right: 30,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset("assets/images/default.png", width: 350, height: 350,), // Specify your image path
                SizedBox(
                  width: 250,
                  child: TextButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          color: kDarkBlueColor,
                          width: 2
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignInPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Sign In",
                      style: TextStyle(color: kDarkBlueColor, fontSize: 18, fontFamily: "Archivo", fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 252,
                  child: TextButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kDarkBlueColor,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: "Archivo", fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
