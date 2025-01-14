import 'package:a5er_elshare3/core/validators/validators.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/RoundedAppBar.dart';
import '../data/Database/FirebaseAuthentication.dart';


class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  Validators validators = Validators();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFDFDFF),
      appBar: const RoundedAppBar(height: 150, title: "Reset Password", color: kDarkBlueColor,),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/images/forgotPassword.png"),
              const Text(
                "Write your email to reset your password",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: kFontFamilyArchivo,
                    fontSize: 16,
                    color: kDarkBlueColor),
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: formKey,
                child: TextFormField(
                  validator: (value) {
                    return validators.ValidateEmail(value);
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
                        borderSide:
                            const BorderSide(color: kDarkBlueColor, width: 2)),
                  ),
                ),
              ),
              const SizedBox(
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
                      if (formKey.currentState!.validate()) {
                        AuthService auth = AuthService();
                        String message =
                            await auth.forgotPassword(emailController.text);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(message),
                            backgroundColor: message.contains('sent')
                                ? Colors.green
                                : Colors.red,
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Reset Password",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: kFontFamilyArchivo,
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
