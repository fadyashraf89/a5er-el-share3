import 'package:a5er_elshare3/core/validators/validators.dart';
import 'package:a5er_elshare3/features/SignUp/presentation/widgets/PasswordField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/constants.dart';
import '../../../Driver/presentation/screens/DriverHome.dart';
import '../../../Login/presentation/screens/login.dart';
import '../../../Passenger/presentation/screens/PassengerHome.dart';
import '../cubit/signup/signup_cubit.dart';
import '../widgets/TextFormFields.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool showPassword = false, showConfirmPassword = false;
  String? selectedRole = 'Passenger';
  TextEditingController emailController = TextEditingController(),
                        passwordController = TextEditingController(),
                        confirmPasswordController = TextEditingController(),
                        mobileController = TextEditingController(),
                        carPlateController = TextEditingController(),
                        driverLicenseController = TextEditingController(),
                        nameController = TextEditingController(),
                        carModelController = TextEditingController();
  Validators validators = Validators();
  final formKey = GlobalKey<FormState>();


  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    mobileController.dispose();
    carPlateController.dispose();
    driverLicenseController.dispose();
    nameController.dispose();
    carModelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupCubit(),
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Sign Up",
                      style: TextStyle(fontSize: 22, fontFamily: kFontFamilyArchivo),
                    ),
                    const SizedBox(height: 10),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormFields().buildTextFormField(
                            controller: emailController,
                            hintText: 'Email',
                            icon: Icons.email,
                            validator: validators.ValidateEmail,
                          ),
                          const SizedBox(height: 20),

                          PasswordField().buildPasswordFormField(
                            controller: passwordController,
                            hintText: 'Password',
                            obscureText: !showPassword,
                            toggleVisibility: () {
                              setState(() {
                                showPassword = !showPassword;
                              });
                            },
                            validator: validators.ValidatePassword,
                          ),
                          const SizedBox(height: 20),

                          // Confirm password input field
                          PasswordField().buildPasswordFormField(
                            controller: confirmPasswordController,
                            hintText: 'Confirm Password',
                            obscureText: !showConfirmPassword,
                            toggleVisibility: () {
                              setState(() {
                                showConfirmPassword = !showConfirmPassword;
                              });
                            },
                            validator: (value) =>
                                validators.ValidateMatchingPasswords(value, passwordController),
                          ),
                          const SizedBox(height: 20),

                          // Dropdown for role selection
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: DropdownButtonFormField<String>(
                                  value: selectedRole,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedRole = value!;
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
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 3,
                                child: TextFormFields().buildTextFormField(
                                  controller: nameController,
                                  hintText: "Name",
                                  icon: Icons.person,
                                  validator: validators.ValidateName,
                                ),
                              ),
                            ],
                          ),
                          if (selectedRole == 'Driver') buildDriverFields(),
                          const SizedBox(height: 20),

                          TextFormFields().buildTextFormField(
                            controller: mobileController,
                            hintText: 'Mobile Number',
                            icon: Icons.phone,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Please enter your mobile number'
                                : null,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                " Already have an account ?",
                                style: TextStyle(fontFamily: kFontFamilyArchivo),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => const SignInPage()),
                                  );
                                },
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.8),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: kFontFamilyArchivo),
                                ),
                              )
                            ],
                          ),


                          BlocConsumer<SignupCubit, SignupState>(
                            listener: (context, state) {
                              if (state is SignupSuccess) {
                                if (selectedRole == 'Passenger') {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const PassengerHome(),
                                    ),
                                  );
                                } else if (selectedRole == 'Driver') {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const DriverHome(),
                                    ),
                                  );
                                }
                              } else if (state is SignupFailure) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(state.message),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            builder: (context, state) {
                              if (state is SignupLoading) {
                                return const CircularProgressIndicator();
                              }
                              return SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      String? mobileError = await validators.ValidateMobileNumber(mobileController.text);
                                      if (mobileError != null) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(mobileError), backgroundColor: Colors.red),
                                        );
                                        return;
                                      }

                                      if (selectedRole == 'Driver') {
                                        String? licenseError = await validators.ValidateLicenseNumber(driverLicenseController.text);
                                        if (licenseError != null) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text(licenseError), backgroundColor: Colors.red),
                                          );
                                          return; // Stop further execution
                                        }
                                      }

                                      final SignUpCubit = BlocProvider.of<SignupCubit>(context);
                                      SignUpCubit.signUp(
                                        email: emailController.text,
                                        password: passwordController.text,
                                        role: selectedRole!,
                                        name: nameController.text,
                                        mobileNumber: mobileController.text,
                                        carPlateNumber: carPlateController.text,
                                        carModel: carModelController.text,
                                        licenseNumber: driverLicenseController.text,
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("Please fix the errors in the form"),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: kDarkBlueColor,
                                    padding: const EdgeInsets.symmetric(vertical: 15),
                                  ),
                                  child: const Text(
                                    "Sign Up",
                                    style: TextStyle(color: Colors.white, fontFamily: kFontFamilyArchivo),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget buildDriverFields() {
    print("hn3mel driver fields");
    return Column(
      children: [
        const SizedBox(height: 10,),
        TextFormFields().buildTextFormField(
          controller: driverLicenseController,
          hintText: 'Driver License Number',
          icon: Icons.card_travel,
          validator: (value) =>
          value == null || value.isEmpty ? 'Enter your license number' : null,
        ),
        const SizedBox(height: 10),
        TextFormFields().buildTextFormField(
          controller: carModelController,
          hintText: 'Car Model',
          icon: Icons.car_repair,
          validator: (value) =>
          value == null || value.isEmpty ? 'Enter your car model' : null,
        ),
        const SizedBox(height: 10),
        TextFormFields().buildTextFormField(
          controller: carPlateController,
          hintText: 'Car Plate Number',
          icon: Icons.numbers,
          validator: (value) =>
          value == null || value.isEmpty ? 'Enter your car plate number' : null,
        ),
      ],
    );
  }
}
