import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frontend/entities/event.dart';
import 'package:frontend/routing/router.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'constants.dart';
import 'entities/user.dart';

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
    FirebaseAuth.instance.userChanges().listen((user) async {
      if (user != null) {
        final idToken = await user.getIdToken();
        print('ID TOKEN $idToken end_token');
        _loginState = ApplicationLoginState.loggedIn;
        final response = await fetchIdentityUser(await user.getIdToken());
        if (response.statusCode == 200) {
          print(jsonDecode(response.body));
          identityUser = IdentityUser.fromJson(jsonDecode(response.body));
          if (identityUser == null) {
            return;
          }

          IdentityUser iu = IdentityUser(uid: identityUser!.uid);
          final response1 = await updateIdentityUser(iu);
          print(response1.statusCode);
        } else {
          final response =
              await publishIdentityUser(user.uid, await user.getIdToken());
          if (response.statusCode == 200) {
            identityUser = IdentityUser.fromJson(jsonDecode(response.body));
          }
        }
        this.user = user;
      } else {
        _loginState = ApplicationLoginState.loggedOut;
      }
      notifyListeners();
    });
  }

  Future<String?> getAccessToken() async {
    return await _user?.getIdToken();
  }

  Future<http.Response> fetchIdentityUser(String accessToken) async {
    return http.get(Uri.parse('$baseUrl/user'), headers: {
      'Authorization': 'Bearer $accessToken',
    });
  }

  Future<http.Response> updateIdentityUser(IdentityUser user) async {
    final accessToken = await _user?.getIdToken();
    return http.put(
      Uri.parse('$baseUrl/user'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(user),
    );
  }

  Future<http.Response> publishIdentityUser(
      String uid, String accessToken) async {
    return http.post(
      Uri.parse('$baseUrl/user'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        "uid": uid,
      }),
    );
  }

  Future<http.Response> publishNewEvent(Event event) async {
    final accessToken = await user!.getIdToken();
    notifyListeners();
    return http.post(Uri.parse('$baseUrl/event'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(event.toJson()));
  }

  IdentityUser? _identityUser;

  User? _user;
  User? get user => _user;

  IdentityUser? get identityUser => _identityUser;

  set identityUser(IdentityUser? value) {
    print(value);
    _identityUser = value;
    notifyListeners();
  }

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
