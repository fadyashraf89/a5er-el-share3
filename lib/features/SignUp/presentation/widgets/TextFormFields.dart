import 'package:flutter/material.dart';

import '../../../../core/utils/Constants/constants.dart';
class TextFormFields{
  Widget buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30)
          ),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: kDarkBlueColor))

      ),
    );
  }
}