import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class Validators {
  Future<String?> ValidateMobileNumber(String? value) async {
    if (value == null || value.isEmpty) {
      return 'Please Enter Your Mobile Number';
    }

    String? result = await checkMobileNumberInCollections(value);

    if (result != null) {
      return result;
    }

    return null;
  }

  String? ValidateCarModel(String? value) {
    if (value!.isEmpty) {
      return 'Please Enter Your Car Model';
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

  Future<String?> ValidateLicenseNumber(String? value) async {
    if (value!.isEmpty) {
      return 'Please Enter Your License Number';
    }
    String? result = await checkLicenseNumberInCollections(value);

    if (result != null) {
      return result;
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

  void ValidatePickUpAndDestination(TextEditingController pickupController, TextEditingController destinationController, BuildContext context) {
    if (pickupController.text == destinationController.text) {
      ShowMessageDialog(context, "Pick up location and destination can't the same");
    }
    else if (pickupController.text.isEmpty || destinationController.text.isEmpty){
      ShowMessageDialog(context, "Pick up location or destination can't be empty");
    }
  }

  Future<bool> isMobileNumberExists(String mobileNumber, String CollectionName) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection(CollectionName)
          .where('mobileNumber', isEqualTo: mobileNumber)
          .get();

      // Check if any documents match the query
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking mobile number: $e');
      return false;
    }
  }

  Future<bool> isLicenseNumberExists(String LicenseNumber) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Drivers')
          .where('licenseNumber', isEqualTo: LicenseNumber)
          .get();

      // Check if any documents match the query
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking license number: $e');
      return false;
    }
  }

  Future<String?> checkMobileNumberInCollections(String mobileNumber) async {
    try {
      bool inPassengers = await isMobileNumberExists(mobileNumber, 'Passengers');
      bool inDrivers = await isMobileNumberExists(mobileNumber, 'Drivers');

      if (inPassengers || inDrivers) {
        return 'Mobile number Already exists';
      }
    } catch (e) {
      print('Error checking collections: $e');
      return 'Error occurred while checking';
    }
    return null;
  }

  Future<String?> checkLicenseNumberInCollections(String licenseNumber) async {
    try {
      bool inDrivers = await isLicenseNumberExists(licenseNumber);

      if (inDrivers) {
        return 'License number Already exists';
      }
    } catch (e) {
      print('Error checking collections: $e');
      return 'Error occurred while checking';
    }
    return null;
  }

  bool validatePoints(int? tripPoints, int? passengerPoints) {
    if (tripPoints == null || passengerPoints == null) {
      return false;
    }
    return passengerPoints >= tripPoints;
  }

}