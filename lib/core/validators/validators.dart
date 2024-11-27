import 'package:flutter/material.dart';
class Validators {
  String? ValidateMobileNumber(String? value) {
    if (value!.isEmpty) {
      return 'Please Enter Your Mobile Number';
    }
    return null;
  }

  String? ValidateMatchingPasswords(String? value, TextEditingController passwordController) {
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? ValidatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Enter Your Password';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? ValidateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? ValidateLicenseNumber(String? value) {
    if (value!.isEmpty) {
      return 'Please Enter Your License Number';
    }
    return null;
  }

  String? ValidatePlateNumber(String? value) {
    if (value!.isEmpty) {
      return 'Please Enter Your Car Plate Number';
    }
    return null;
  }

  String? ValidateName(String? value) {
    if (value!.isEmpty) {
      return 'Please Enter Your Name';
    }
    return null;
  }

  Future<void> ShowMessageDialog(BuildContext context, String message) async {
    return showDialog<void>(
      context: context, barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          icon: const Icon(
            Icons.error_outlined,
            color: Colors.red,
            size: 30,
          ),
          title: const Text('Error'),
          content: SingleChildScrollView(
            child: Center(
                child:
                Text(message)),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void ValidatePickUpAndDestination(TextEditingController pickupController,
      TextEditingController destinationController, BuildContext context) {
    if (pickupController.text == destinationController.text) {
      ShowMessageDialog(context, "Pick up location and destination can't the same");
    }
    else if (pickupController.text.isEmpty || destinationController.text.isEmpty){
      ShowMessageDialog(context, "Pick up location or destination can't be empty");
    }
  }

}