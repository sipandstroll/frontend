import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginButtonWidget extends StatelessWidget {
  final String text;
  final String icon;
  const LoginButtonWidget({
    Key? key,
    required this.text,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 1.2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              textStyle: const TextStyle(
                color: Colors.white,
                letterSpacing: 0.5,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Positioned(
            left: 15,
            child: SvgPicture.asset(
              icon,
              height: 18,
              width: 18,
            ),
          ),
        ],
      )
    );
  }
}