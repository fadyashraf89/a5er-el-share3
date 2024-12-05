import 'package:a5er_elshare3/core/validators/validators.dart';
import 'package:a5er_elshare3/features/Authentication/presentation/screens/signup.dart';
import 'package:flutter/material.dart';
import '../../../Driver/presentation/screens/DriverHome.dart';
import '../../../Passenger/presentation/screens/PassengerHome.dart';
import '../../../../core/utils/constants.dart';
import '../cubits/AuthenticationCubit/auth_cubit.dart';
import 'ForgotPassword.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool showPassword = false;
  IconData icon = Icons.visibility_off;

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final Validators validators = Validators();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => AuthCubit(),
  child: Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthLoading) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const Center(child: CircularProgressIndicator(
                      color: Colors.white,
                    )),
                  );
                } else if (state is AuthSuccess) {
                  Navigator.of(context).pop(); // Dismiss loading dialog

                  // Navigate based on role
                  if (state.role == 'Passenger') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const PassengerHome()),
                    );
                  } else if (state.role == 'Driver') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const DriverHome()),
                    );
                  }
                } else if (state is AuthFailure) {
                  Navigator.of(context).pop(); // Dismiss loading dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child: Image.asset("assets/images/default.png",
                            width: 350, height: 350)),
                    const Text(
                      "Sign In",
                      style: TextStyle(fontSize: 22, fontFamily: "Archivo"),
                    ),
                    const SizedBox(height: 10),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          // Email Input Field
                          TextFormField(
                            validator: (value) {
                              return validators.ValidateEmail(value);
                            },
                            controller: emailController,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              hintStyle: const TextStyle(fontFamily: "Archivo"),
                              prefixIcon: const Icon(Icons.email),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(color: kDarkBlueColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                    color: kDarkBlueColor, width: 2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Password Input Field
                          TextFormField(
                            validator: (value) {
                              return validators.ValidatePassword(value);
                            },
                            controller: passwordController,
                            obscureText: !showPassword,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              hintStyle: const TextStyle(fontFamily: "Archivo"),
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
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(color: kDarkBlueColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                    color: kDarkBlueColor, width: 2),
                              ),
                            ),
                          ),

                          // Forgot Password
                          Padding(
                            padding: const EdgeInsets.only(right: 220.0),
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const ForgotPassword(),
                                ));
                              },
                              child: Text(
                                "Forgot Password",
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.8),
                                    fontFamily: "Archivo"),
                              ),
                            ),
                          ),

                          // Sign In Button
                          SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    const Color(0xff1d198b)),
                              ),
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  context.read<AuthCubit>().signIn(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                  );
                                }
                              },
                              child: const Text(
                                "Sign In",
                                style: TextStyle(color: Color(0xffFFFFFF), fontFamily: "Archivo"),
                              ),
                            ),
                          ),

                          // Redirect to Sign Up
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't have an account ?", style: TextStyle(
                                  fontFamily: "Archivo"
                              ),),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => const SignUpPage()),
                                  );
                                },
                                child: Text(
                                  "Register Now",
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.8),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Archivo"

                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    ),
);
  }
}