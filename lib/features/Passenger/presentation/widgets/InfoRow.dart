import "package:flutter/material.dart";

import "../../../../core/utils/constants.dart";
Widget infoRow(String label, String? value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Label with overflow handling
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: kDarkBlueColor,
            ),
            overflow: TextOverflow.ellipsis, // Handle overflow
            maxLines: 1, // Prevent overflow in label
          ),
        ),
        // Value with overflow handling
        Expanded(
          child: Text(
            value ?? 'N/A', // Handle null values
            maxLines: 10, // Limit to a single line
            overflow: TextOverflow.visible, // Truncate with ellipsis if too long
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ),
      ],
    ),
  );
}