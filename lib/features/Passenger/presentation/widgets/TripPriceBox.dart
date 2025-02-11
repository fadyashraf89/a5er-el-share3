import 'package:a5er_elshare3/core/utils/Constants/constants.dart';
import "package:flutter/material.dart";


class TripPrice extends StatelessWidget {
  final double? price;

  const TripPrice({super.key, this.price});

  @override
  Widget build(BuildContext context) {
    return Text(
      price != null
          ? "${price!.toStringAsFixed(2)} \$"
          : "Trip Price Unavailable",
      style: const TextStyle(
        color: kDarkBlueColor,
        fontSize: 32,
      ),
    );
  }
}
