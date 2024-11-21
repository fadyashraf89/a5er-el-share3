import 'package:a5er_elshare3/core/validators/validators.dart';
import 'package:a5er_elshare3/features/Driver/data/database/DriverStorage.dart';
import 'package:flutter/material.dart';

import '../../../Passenger/data/Database/PassengerStorage.dart';
import '../../../Passenger/data/models/Passenger.dart';
import '../../data/Database/FirebaseAuthentication.dart';
import '../../../Driver/data/models/driver.dart';
import '../../../../core/utils/constants.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool showPassword = false;
  bool showConfirmPassword = false;
  IconData icon = Icons.visibility_off;
  String? selectedRole = 'Passenger';
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController carPlateController = TextEditingController();
  TextEditingController driverLicenseController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  Validators validators = Validators();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    mobileController.dispose();
    carPlateController.dispose();
    driverLicenseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                    child:
                        Image.asset("assets/images/default.png", height: 140)),
                const Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 22, fontFamily: "Archivo"),
                ),
                const SizedBox(height: 10),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      // Email input field
                      TextFormField(
                        validator: (value) {
                          return validators.ValidateEmail(value);
                        },
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Password input field
                      TextFormField(
                        validator: (value) {
                          return validators.ValidatePassword(value);
                        },
                        controller: passwordController,
                        obscureText: !showPassword,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          prefixIcon: const Icon(Icons.password),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                showPassword = !showPassword;
                                icon = showPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off;
                              });
                            },
                            icon: Icon(icon),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Confirm password input field
                      TextFormField(
                        validator: (value) {
                          return validators.ValidateMatchingPasswords(value, passwordController);
                        },
                        controller: confirmPasswordController,
                        obscureText: !showConfirmPassword,
                        decoration: InputDecoration(
                          hintText: 'Confirm Password',
                          prefixIcon: const Icon(Icons.password),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                showConfirmPassword = !showConfirmPassword;
                              });
                            },
                            icon: Icon(showConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Dropdown to select role
                      DropdownButtonFormField<String>(
                        value: selectedRole,
                        hint: const Text('Select Role'),
                        onChanged: (value) {
                          setState(() {
                            selectedRole = value;
                          });
                        },
                        items: const [
                          DropdownMenuItem(
                            value: 'Driver',
                            child: Text('Driver'),
                          ),
                          DropdownMenuItem(
                            value: 'Passenger',
                            child: Text('Passenger'),
                          ),
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Additional fields for Driver
                      if (selectedRole == 'Driver')
                        Column(
                          children: [
                            TextFormField(
                              validator: (value) {
                                return validators.ValidateLicenseNumber(value);
                              },
                              controller: driverLicenseController,
                              decoration: InputDecoration(
                                hintText: 'Driver License Number',
                                prefixIcon: const Icon(Icons.card_travel),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              validator: (value) {
                                return validators.ValidatePlateNumber(value);
                              },
                              controller: carPlateController,
                              decoration: InputDecoration(
                                hintText: 'Car Plate Number',
                                prefixIcon: const Icon(Icons.car_repair),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 20),

                      // Mobile number input field
                      TextFormField(
                        validator: (value) {
                          return validators.ValidateMobileNumber(value);
                        },
                        controller: mobileController,
                        decoration: InputDecoration(
                          hintText: 'Mobile Number',
                          prefixIcon: const Icon(Icons.phone),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(" Already have an account ?"),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.8),
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Sign Up button
                      SizedBox(
                        height: 45,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(kDarkBlueColor),
                          ),
                          onPressed: () async {
                            await SignUp(context);
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> SignUp(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      Authentication auth = Authentication();
      String message = await auth.registerWithEmailAndPassword(
        emailController.text,
        passwordController.text,
      );

      if (message.contains('successful')) {
        String? uid = await auth.getCurrentUserUid();
        if (uid != null) {
          DriverStorage Dstorage = DriverStorage();
          PassengerStorage Pstorage = PassengerStorage();
          if (selectedRole == 'Passenger') {
            Passenger passenger = Passenger(
              email: emailController.text,
              mobileNumber: mobileController.text,
              uid: uid,
              role: "Passenger",
            );
            await Pstorage.addPassenger(passenger);
          } else if (selectedRole == 'Driver') {
            Driver driver = Driver(
              email: emailController.text,
              mobileNumber: mobileController.text,
              uid: uid,
              carPlateNumber: carPlateController.text,
              licenseNumber: driverLicenseController.text,
              role: "Driver",
            );
            await Dstorage.addDriver(driver);
          }
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: message.contains('successful') ? Colors.green : Colors.red,
        ),
      );
    }
  }
}

