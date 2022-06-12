import 'package:flutter/material.dart';
import '../constants.dart';


class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        color: Colors.white54,
        child: const Icon(
          Icons.chat,
          size: 350,

          color: Constants.c_blue,
        ),
      ),
    );
  }
}



























