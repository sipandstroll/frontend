import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:flutter/services.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/pages/profile_page.dart';


import 'chat.dart';
import 'events.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedPage = 0;
  final List<Widget> _widgetOptions = <Widget>[
    EventsPage(),
    ChatPage()
  ];

  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          elevation: 0,

            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness:Brightness.dark,
            ),
          title: Container(
            child: RadiantGradientMask(child: const ImageIcon(
              AssetImage('assets/logo_nume_lowercase.png'),
              color: Colors.white,
              size: 200,
            ),
            )
          ),
          leading: GestureDetector(
            child: const Icon(
              Icons.account_circle_rounded,
              size:50,
              color: Colors.black,
            ),
            onTap: () {
              context.go('/home/profile');
            },
          )
        ),
        bottomNavigationBar: BottomNavigationBar(
          iconSize: 25,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.message_rounded),
              label: 'Chat',
            ),
          ],
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: Constants.c_green,
          unselectedItemColor: Constants.c_purple,
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: _widgetOptions,
        )

    );
  }
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
        ],).createShader(bounds),
      child: child,
    );
  }
}
