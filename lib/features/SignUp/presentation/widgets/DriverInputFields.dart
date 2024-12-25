import "package:flutter/material.dart";

import "TextFormFields.dart";
class DriverInputFields{
  TextEditingController carPlateController = TextEditingController(),
                        driverLicenseController = TextEditingController(),
                        carModelController = TextEditingController();
  Widget buildDriverFields() {
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
  }}