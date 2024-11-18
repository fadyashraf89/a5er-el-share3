import 'dart:io'; // Required for File (if you were using File elsewhere)
import 'package:a5er_elshare3/screens/authentication/login.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool showPassword = false;
  bool showConfirmPassword = false;
  IconData icon = Icons.visibility_off;
  String? selectedRole = 'Passenger'; // Set default value as 'Passenger'
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController carPlateController = TextEditingController();
  TextEditingController driverLicenseController = TextEditingController(); // Driver's license number
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
                Center(child: Image.asset("assets/images/default.png", height: 140)),
                const Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 22, fontFamily: "Archivo"),
                ),
                const SizedBox(
                  height: 10,
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Your Email';
                          }
                          return null;
                        },
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                  color: Colors.black.withOpacity(0.5))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 2)),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
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
                                if (showPassword) {
                                  icon = Icons.visibility;
                                } else {
                                  icon = Icons.visibility_off;
                                }
                              });
                            },
                            icon: Icon(icon),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                  color: Colors.black.withOpacity(0.5))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 2)),
                        ),
                      ),
                      const SizedBox(height: 20),
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
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                  color: Colors.black.withOpacity(0.5))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 2)),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Dropdown to select role (Driver or Passenger)
                      DropdownButtonFormField<String>(
                        value: selectedRole, // Default value set here
                        hint: Text('Select Role'),
                        onChanged: (value) {
                          setState(() {
                            selectedRole = value;
                          });
                        },
                        items: [
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
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Show fields based on selected role
                      if (selectedRole == 'Driver')
                        Column(
                          children: [
                            // Field for driver's license number
                            TextFormField(
                              controller: driverLicenseController,
                              decoration: InputDecoration(
                                hintText: 'Driver License Number',
                                prefixIcon: const Icon(Icons.card_travel),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                    width: 2,
                                  ),
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
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),

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
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                  color: Colors.black.withOpacity(0.5))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 2)),
                        ),
                      ),
                      const SizedBox(height: 20),

                      SizedBox(
                        height: 45,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all(Color(0xff1d198b)),
                          ),
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              // Perform Sign Up
                            }
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(color: Color(0xffFFFFFF)),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account?"),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                  const SignInPage(), // Pass the email to home screen
                                ),
                              );
                            },
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.8),
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
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
