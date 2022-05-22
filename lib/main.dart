import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frontend/routing/router.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
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
              primarySwatch: Colors.blue,
            ),
          );
        },
      ),
    );
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
        this.user = user;
      } else {
        _loginState = ApplicationLoginState.loggedOut;
      }
      notifyListeners();
    });
  }

  User? _user;
  User? get user => _user;
  set user(User? phoneNumber) {
    _user = phoneNumber;
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
