import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/pages/phone_number.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';
import '../widgets/login_button_widget.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                Constants.c_green,
                Constants.c_purple,
              ],)
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const ImageIcon(
                AssetImage('assets/logo.png'),
                color: Colors.white,
                size: 70,
              ),
              const Text(
                'sip&stroll',
                style: TextStyle(
                    fontFamily: 'Comfortaa',
                    fontWeight: FontWeight.w700,
                    fontSize: 35,
                    color: Colors.white,
                ),
              ),
              const SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text:
                            'By tapping Create Account or Sign In, you agree to our\n',
                        style: kNormalText,
                      ),
                      TextSpan(
                        text: 'Terms',
                        style: kUnderlinedText,
                      ),
                      TextSpan(
                        text: '. Learn how we process your data in our ',
                        style: kNormalText,
                      ),
                      TextSpan(
                        text: 'Privacy\nPolicy',
                        style: kUnderlinedText,
                      ),
                      TextSpan(
                        text: ' and ',
                        style: kNormalText,
                      ),
                      TextSpan(
                        text: 'Cookies Policy',
                        style: kUnderlinedText,
                      ),
                      TextSpan(
                        text: '.',
                        style: kNormalText,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const LoginButtonWidget(
                text: 'SIGN IN WITH APPLE',
                icon: 'assets/apple_logo.svg',
              ),
              const LoginButtonWidget(
                text: 'SIGN IN WITH FACEBOOK',
                icon: 'assets/facebook_logo.svg',
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PhoneNumberWidget()));
                },
                child: const LoginButtonWidget(
                  text: 'SIGN IN WITH PHONE NUMBER',
                  icon: 'assets/message.svg',
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Trouble Signing In?',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
