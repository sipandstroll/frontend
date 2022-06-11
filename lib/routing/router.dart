import 'package:frontend/main.dart';
import 'package:frontend/pages/edit_profile_page.dart';
import 'package:frontend/pages/home.dart';
import 'package:frontend/pages/login_page.dart';
import 'package:frontend/pages/profile_page.dart';
import 'package:go_router/go_router.dart';

// TODO: REFACTOR
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
        path: '/home',
        name: 'home',
        routes: [
          GoRoute(
            path: 'profile',
            name: 'profile',
            builder: (context, state) => const ProfilePage(),
            routes: [
              GoRoute(
                  path: 'edit',
                  name: 'edit',
                  builder: (context, state) => const EditProfilePage())
            ],
          )
        ],
        builder: (context, state) => const HomePage(),
      ),
    ],
    // errorBuilder: (context, state) => ErrorPage(error: state.error.toString()),
    redirect: (state) {
      final loggingIn = state.subloc == '/login';

      final isLoggedIn =
          appService.loginState == ApplicationLoginState.loggedIn;

      // user is not logged in, if it s already on log in page do nothing, else reridrect to '/login'
      if (!isLoggedIn) return loggingIn ? null : '/login';
      if (loggingIn) return '/home';

      return null;
    },
  );
}
