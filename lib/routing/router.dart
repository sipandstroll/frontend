import 'package:frontend/main.dart';
import 'package:frontend/pages/home.dart';
import 'package:frontend/pages/login_page.dart';
import 'package:frontend/pages/profile_page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  late final ApplicationState appService;

  GoRouter get router => _goRouter;

  AppRouter(this.appService);

  late final GoRouter _goRouter = GoRouter(
    refreshListenable: appService,
    initialLocation: '/login',
    routes: <GoRoute>[
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
    ],
    // errorBuilder: (context, state) => ErrorPage(error: state.error.toString()),
    redirect: (state) {
      final loginLocation = state.namedLocation('login');
      final profileLocation = state.namedLocation('profile');
      final homeLocation = state.namedLocation('home');

      final isLogedIn = appService.loginState == ApplicationLoginState.loggedIn;

      final isGoingToLogin = state.subloc == loginLocation;
      final isGoingToProfile = state.subloc == profileLocation;
      final isGoingToHome = state.subloc == homeLocation;

      // TODO: Replace duplicate strings, use enums
      if (!isLogedIn && !isGoingToLogin) return loginLocation;
      if (isLogedIn && !isGoingToHome && !isGoingToProfile) return homeLocation;
      if (isLogedIn && !isGoingToProfile && !isGoingToHome) {
        return profileLocation;
      }
      return null;
    },
  );
}
