import 'package:a5er_elshare3/shared/data/models/Passenger.dart';
import 'package:a5er_elshare3/shared/data/models/driver.dart';
import 'package:a5er_elshare3/shared/data/Database/FirebaseAuthentication.dart';
import 'package:flutter/material.dart';
import '../../../core/utils/constants.dart';
import '../../../shared/data/Database/FirebaseStorage.dart';

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
                          if (value == null || value.isEmpty) {
                            return 'Please enter an email';
                          } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                              .hasMatch(value)) {
                            return 'Enter a valid email';
                          }
                          return null;
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
                          if (value!.isEmpty) {
                            return 'Please Enter Your Password';
                          }
                          return null;
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
                          if (value != passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
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
                          if (value!.isEmpty) {
                            return 'Please Enter Your Mobile Number';
                          }
                          return null;
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
                            if (formKey.currentState!.validate()) {
                              Authentication auth = Authentication();
                              String message =
                                  await auth.registerWithEmailAndPassword(
                                emailController.text,
                                passwordController.text,
                              );

                              if (message.contains('successful')) {
                                String? uid = await auth.getCurrentUserUid();
                                if (uid != null) {
                                  if (selectedRole == 'Passenger') {
                                    Passenger passenger = Passenger(
                                        email: emailController.text,
                                        mobileNumber: mobileController.text,
                                        uid: uid,
                                        role: "Passenger");

                                    Storage storage = Storage();
                                    await storage.addPassenger(passenger);
                                  } else if (selectedRole == 'Driver') {
                                    Driver driver = Driver(
                                        email: emailController.text,
                                        mobileNumber: mobileController.text,
                                        uid: uid,
                                        carPlateNumber: carPlateController.text,
                                        licenseNumber:
                                            driverLicenseController.text,
                                        role: "Driver");

                                    Storage storage = Storage();
                                    await storage.addDriver(driver);
                                  }
                                }
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(message),
                                  backgroundColor:
                                      message.contains('successful')
                                          ? Colors.green
                                          : Colors.red,
                                ),
                              );
                            }
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
}
