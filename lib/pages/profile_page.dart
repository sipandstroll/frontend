import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/main.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

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
        ),
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: (){
            context.pop();
          },
          child: Icon(Icons.arrow_back_ios_rounded, color: Colors.black,),
        ),
        elevation: 0,
      ),
      body: SafeArea(
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
                      'Profile Page :D',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  const SizedBox(height: 60),
                  Consumer<ApplicationState>(
                    builder: (context, appState, _) => Column(
                      children: [
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
        ),
      ),
    );
  }
}
