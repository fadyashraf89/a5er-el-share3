import 'package:a5er_elshare3/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ThreeDotsAnimation extends StatelessWidget {
  const ThreeDotsAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SpinKitThreeBounce(
        color: kDarkBlueColor,
        size: 30.0,
      ),
    );
  }
}
