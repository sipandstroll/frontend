import 'package:flutter/material.dart';

const baseUrl = 'http://192.168.0.199:3000';

const kNormalText = TextStyle(
  fontSize: 12,
  color: Colors.white,
);

const kUnderlinedText = TextStyle(
  fontSize: 12,
  color: Colors.white,
  decoration: TextDecoration.underline,
  fontWeight: FontWeight.w500,
);

class Constants {
  static const Color c_purple = Color(0xff6B357F);
  static const Color c_blue = Color(0xff00A1BA);
  static const Color c_green = Color(0xff36C486);
  static const Color c_pink = Color(0xffFF39BA);
  static const Color c_red = Color(0xffED254E);
  static const Color c_yellow = Color(0xffF9DC5C);

  static const String otpGifImage = "assets/otp.gif";
}

class RadiantGradientMask extends StatelessWidget {
  RadiantGradientMask({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: [
          Constants.c_purple,
          Constants.c_green,
        ],
      ).createShader(bounds),
      child: child,
    );
  }
}
