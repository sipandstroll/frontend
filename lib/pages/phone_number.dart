import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/pages/verification_code_page.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PhoneNumberWidget extends StatefulWidget {
  const PhoneNumberWidget({Key? key}) : super(key: key);

  @override
  State<PhoneNumberWidget> createState() => _PhoneNumberWidgetState();
}

class _PhoneNumberWidgetState extends State<PhoneNumberWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [Constants.c_green, Constants.c_purple],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          )),
        ),
        elevation: 0,
        title: Container(
          child: const ImageIcon(
            AssetImage('assets/logo_nume_lowercase.png'),
            color: Colors.white,
            size: 200,
          ),

        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 50,),
              Expanded(
                child: RadiantGradientMask(
                  child: const ImageIcon(
                    AssetImage('assets/verification_icon.png'),
                    color: Colors.white,
                    size: 200,
                  ),
                ),
              ),
              SizedBox(height: 50,),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    'Verify Your Phone Number',
                    style: Theme.of(context).textTheme.headline5,
                  ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Please confirm your country code\n and enter your phone number',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              //const SizedBox(height: 20),
              Expanded(
                flex: 2,
                child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: PhoneNumWTest(),
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PhoneNumWTest extends StatefulWidget {
  @override
  _PhoneNumWTestState createState() => _PhoneNumWTestState();
}

class _PhoneNumWTestState extends State<PhoneNumWTest> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController controller = TextEditingController();
  String initialCountry = 'RO';
  PhoneNumber number = PhoneNumber(isoCode: 'RO');
  String? _verificationCode;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {
                this.number = number;
              },
              selectorConfig: const SelectorConfig(
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                trailingSpace: false,
              ),
              ignoreBlank: false,
              autoValidateMode: AutovalidateMode.disabled,
              selectorTextStyle: const TextStyle(color: Colors.black),
              initialValue: number,
              textFieldController: controller,
              formatInput: false,
              keyboardType: const TextInputType.numberWithOptions(
                  signed: true, decimal: true),
              inputBorder: InputBorder.none,
              onSaved: (PhoneNumber number) {
                print('On Saved: $number');
              },
            ),
            ElevatedButton(
              onPressed: () async {
                // TODO: Refactor logic, component shouldn't know about user logging or Firebase, move logic to a business service or state might be better way
                if (formKey.currentState?.validate() != false) {
                  formKey.currentState?.save();
                  print('Message sent to: ${number.phoneNumber}');
                  var phoneNum = number.phoneNumber;
                  if (phoneNum != null) {
                    await _verifyPhone(phoneNum,
                        (String verificationCode, int? forceResendingToken) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CodeVerification(
                                phoneNum ?? 'ceva', verificationCode)),
                      );
                      print('VERIFICATION CODEl $_verificationCode');
                    });
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Constants.c_purple,
              ),
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }

  _verifyPhone(String phoneNumber, PhoneCodeSent codeSent) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // PASS - ANDROID ONLY TO AUTO VERIFY
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: codeSent,
        codeAutoRetrievalTimeout: (String verificationID) {
          if (this.mounted) {
            setState(() {
              _verificationCode = verificationID;
            });
          }
        },
        timeout: Duration(seconds: 120));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
