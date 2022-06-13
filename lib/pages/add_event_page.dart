import 'package:flutter/material.dart';
import '../constants.dart';


class AddEventPage extends StatelessWidget {
  const AddEventPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        color: Colors.white,
        child: const ImageIcon(
          AssetImage('assets/add_icon.png'),
          size: 350,

          color: Constants.c_blue,
        ),
      ),
    );
  }
}
