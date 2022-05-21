import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class CodeVerification extends StatefulWidget {
  final String phoneNumber;
  final String verificationCode;
  const CodeVerification(this.phoneNumber, this.verificationCode, {Key? key})
      : super(key: key);

  @override
  State<CodeVerification> createState() => _CodeVerificationState();
}

class _CodeVerificationState extends State<CodeVerification> {
  TextEditingController textEditingController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  StreamController<ErrorAnimationType>? errorController;
  String currentText = "";
  bool hasError = false;
  String? currentCode;

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();
    super.dispose();
  }

  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: Theme.of(context).primaryColorDark,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.only(left: 30, top: 20, right: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Code verification',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                      const SizedBox(height: 60),
                      RichText(
                        text: TextSpan(
                            text: "Enter the code sent to ",
                            children: [
                              TextSpan(
                                  text: widget.phoneNumber,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                            ],
                            style: const TextStyle(
                                color: Colors.black54, fontSize: 15)),
                        textAlign: TextAlign.center,
                      ),
                      Form(
                        key: formKey,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 30),
                          child: PinCodeTextField(
                            appContext: context,
                            length: 6,
                            onChanged: (String value) async {
                              if (value != currentCode) {
                                currentCode = value;
                                if (currentCode == null || value.length != 6) {
                                  return;
                                }
                                var phoneAuthCredentials =
                                    PhoneAuthProvider.credential(
                                        verificationId: widget.verificationCode,
                                        smsCode: value);
                                await FirebaseAuth.instance
                                    .signInWithCredential(phoneAuthCredentials);
                                formKey.currentState?.validate();
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
