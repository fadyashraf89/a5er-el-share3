import 'package:a5er_elshare3/core/validators/validators.dart';
import 'package:a5er_elshare3/features/Authentication/presentation/screens/signup.dart';
import 'package:flutter/material.dart';
import '../../data/Database/FirebaseAuthentication.dart';
import '../../../../core/utils/constants.dart';
import 'ForgotPassword.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool showPassword = false;
  IconData icon = Icons.visibility_off;

  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  Validators validators = Validators();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      Authentication auth = Authentication();
      String message = await auth.SignInWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor:
              message.contains('successful') ? Colors.green : Colors.red,
        ),
      );

      if (message.contains('successful')) {}
    }
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
                          onPressed: () async {
                            await _signIn(context);
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpPage(),
                                ),
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
            ),
          ),
        ),
      ),
    );
  }
}
