import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/main.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          padding: const EdgeInsets.only(left: 30, top: 20, right: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Profile',
                  style: TextStyle(fontSize: 25),
                ),
              ),
              Consumer<ApplicationState>(
                builder: (context, appState, _) => Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    (appState.identityUser?.profilePicture != null &&
                            appState.identityUser?.profilePicture != '')
                        ? CircleAvatar(
                            radius: 65,
                            foregroundImage: NetworkImage(
                                appState.identityUser?.profilePicture ?? ''),
                            backgroundColor: Constants.c_blue,
                            child: const Icon(
                              Icons.person_rounded,
                              color: Colors.white54,
                              size: 70,
                            ),
                          )
                        : const Icon(
                            Icons.person_rounded,
                            color: Constants.c_green,
                          ),
                    SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Username:',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    appState.user?.displayName != ''
                        ? Text(appState.user?.displayName ?? 'N/A')
                        : Text('unknown'),
                    SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Email:',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    appState.user?.email != ''
                        ? Text(appState.user?.email ?? 'N/A')
                        : Text('unknown'),
                    SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Age:',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text('unknown'),
                    SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Phone Number:',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    // TODO: Remap user object to a wrapper ( onion architecture ), agnostic of firebase model

                    Text(appState.user?.phoneNumber ?? 'N/A'),
                    TextButton(
                      onPressed: () => {context.goNamed('edit')},
                      child: const Text('EDIT PROFILE'),
                    ),
                    TextButton(
                      onPressed: () => {appState.logout()},
                      child: const Text(
                        'LOGOUT',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
