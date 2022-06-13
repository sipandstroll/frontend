import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:flutter/services.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/pages/profile_page.dart';


import 'add_event_page.dart';
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
    AddEventPage(),
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
              activeIcon: ImageIcon(
                AssetImage('assets/home_icon.png'),
                color: Constants.c_green,
              ),
              icon: ImageIcon(
                AssetImage('assets/home_icon.png'),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              activeIcon: ImageIcon(
                AssetImage('assets/add_icon.png'),
                color: Constants.c_blue,
              ),
              icon: ImageIcon(
                AssetImage('assets/add_icon.png'),
              ),
              label: 'Add Event'
            ),
            BottomNavigationBarItem(
              activeIcon: ImageIcon(
                AssetImage('assets/chat_icon.png'),
                color: Constants.c_purple,
              ),
                icon: ImageIcon(
                  AssetImage('assets/chat_icon.png'),
                ),
              label: 'Chat',
            ),
          ],
          showSelectedLabels: false,
          showUnselectedLabels: false,
          unselectedItemColor: Colors.black26,
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



