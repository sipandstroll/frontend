import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/pages/phone_number.dart';

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
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFFED7263),
              Color(0xFFEA4A77),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SvgPicture.asset(
                'assets/tinder_logo.svg',
                height: 40,
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

class FirstRoute extends StatelessWidget {
  const FirstRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First Route'),
      ),
      body: Center(
        child: ElevatedButton(
            child: const Text('Open route'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PhoneNumberWidget()),
              );
            }),
      ),
    );
  }
}