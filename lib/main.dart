import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frontend/pages/login_page.dart';
import 'package:frontend/routing/router.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChangeNotifierProvider(
    create: (context) => ApplicationState(),
    builder: (context, _) => const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  late ApplicationState appState;

  void initState() {
    appState = ApplicationState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Inspired from: https://blog.ishangavidusha.com/flutter-authentication-flow-with-go-router-and-provider#comments-list
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ApplicationState>(create: (_) => appState),
        Provider<AppRouter>(create: (_) => AppRouter(appState)),
      ],
      child: Builder(
        builder: (context) {
          final GoRouter goRouter =
              Provider.of<AppRouter>(context, listen: false).router;
          return MaterialApp.router(
            title: "Router App",
            routeInformationParser: goRouter.routeInformationParser,
            routerDelegate: goRouter.routerDelegate,
            theme: ThemeData(
              // This is the theme of your application.
              //
              // Try running your application with "flutter run". You'll see the
              // application has a blue toolbar. Then, without quitting the app, try
              // changing the primarySwatch below to Colors.green and then invoke
              // "hot reload" (press "r" in the console where you ran "flutter run",
              // or simply save your changes to "hot reload" in a Flutter IDE).
              // Notice that the counter didn't reset back to zero; the application
              // is not restarted.
              primarySwatch: Colors.blue,
            ),
          );
        },
      ),
    );
    // return MaterialApp(
    //     title: 'Flutter Demo',
    //     theme: ThemeData(
    //       // This is the theme of your application.
    //       //
    //       // Try running your application with "flutter run". You'll see the
    //       // application has a blue toolbar. Then, without quitting the app, try
    //       // changing the primarySwatch below to Colors.green and then invoke
    //       // "hot reload" (press "r" in the console where you ran "flutter run",
    //       // or simply save your changes to "hot reload" in a Flutter IDE).
    //       // Notice that the counter didn't reset back to zero; the application
    //       // is not restarted.
    //       primarySwatch: Colors.blue,
    //     ),
    //     home: const LoginPage());
  }
}

class ApplicationState extends ChangeNotifier {
  ApplicationLoginState _loginState = ApplicationLoginState.loggedOut;
  ApplicationLoginState get loginState => _loginState;

  ApplicationState() {
    init();
  }

  void init() {
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loginState = ApplicationLoginState.loggedIn;
      } else {
        _loginState = ApplicationLoginState.loggedOut;
      }
      notifyListeners();
    });
  }

  User? _user;
  User? get user => _user;
  set user(User? phoneNumber) {
    this._user = phoneNumber;
    notifyListeners();
  }

  void logout() {
    FirebaseAuth.instance.signOut();
  }
}

enum ApplicationLoginState {
  loggedOut,
  loggedIn,
}
