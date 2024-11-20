import 'package:flutter/material.dart';

import '../../../core/utils/constants.dart';
import '../../../shared/data/Database/FirebaseAuthentication.dart';
import '../../../shared/widgets/RoundedAppBar.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFDFDFF),
      appBar: RoundedAppBar(title: "Forgot Password"),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/images/forgotPassword.png"),
              Text(
                "Write your email to reset your password",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "Archivo",
                    fontSize: 16,
                    color: kDarkBlueColor),
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: formKey,
                child: TextFormField(
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
                        borderSide: const BorderSide(color: kDarkBlueColor)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                            color: kDarkBlueColor, width: 2)),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 45,
                width: double.infinity,
                child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all(kDarkBlueColor),
                    ),
                    onPressed: () async {
                      if (formKey.currentState!.validate()){
                        Authentication auth = Authentication();
                        String message = await auth.forgotPassword(emailController.text);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(message),
                            backgroundColor: message.contains('sent') ? Colors.green : Colors.red,
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: Text ("Reset Password", style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "Archivo",
                    fontSize: 16,
                    color: Colors.white))),
              )

            ],
          ),
        ),
      ),
    );
  }
}
