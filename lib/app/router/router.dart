import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medicity_app/core/constants/app_routes.dart';
import 'package:medicity_app/features/auth/presentation/screens/log_in_page.dart';
import 'package:medicity_app/features/entry/presentation/screens/splash_screen.dart';
import 'package:medicity_app/features/entry/presentation/screens/welcome_screen.dart';
import 'package:medicity_app/features/home/presentation/screens/home_page.dart';
import '../../features/auth/presentation/screens/set_password_page.dart';
import '../../features/auth/presentation/screens/sign_up_page.dart';
import '../../features/home/presentation/screens/doctors_page.dart';
import '../../shared/widgets/custom_bottom_nav_bar.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final GoRouter router = GoRouter(
    debugLogDiagnostics: kDebugMode,
    initialLocation: AppRoutePaths.splashScreen,
    // redirect: (context, state) async {
    //   final auth = context.read<LoginCubit>();
    //   final loggedIn = await auth.isLoggedIn();

    //   final loggingIn = state.matchedLocation == AppRoutePaths.loginPage ||
    //       state.matchedLocation == AppRoutePaths.welcomePage;

    //   if (!loggedIn && !loggingIn) {
    //     return AppRoutePaths.loginPage;
    //   }

    //   if (loggedIn && loggingIn) {
    //     return AppRoutePaths.homePage;
    //   }

    //   return null;
    // },
    navigatorKey: _rootNavigatorKey,
    routes: [
      ShellRoute(
        builder: (context, state, child) =>
            CustomBottomNavigationBar(state: state, child: child),
        routes: [
          GoRoute(
            path: AppRoutePaths.homePage,
            name: AppRouteNames.homePage,
            builder: (context, state) {
              return HomePage();
            },
          ),
        ],
      ),
      GoRoute(
        path: AppRoutePaths.splashScreen,
        name: AppRouteNames.splashScreen,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutePaths.welcomeScreen,
        name: AppRouteNames.welcomeScreen,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: AppRoutePaths.loginPage,
        name: AppRouteNames.loginPage,
        builder: (context, state) {
          final fromWelcome = state.extra as bool? ?? false;
          return LogInPage(isFromWelcome: fromWelcome);
        },
      ),
      GoRoute(
        path: AppRoutePaths.signUpPage,
        name: AppRouteNames.signUpPage,
        builder: (context, state) {
          final fromWelcome = state.extra as bool? ?? false;
          return SignUpPage(isFromWelcome: fromWelcome);
        },
      ),
      GoRoute(
        path: AppRoutePaths.setPassword,
        name: AppRouteNames.setPassword,
        builder: (context, state) => const SetPasswordPage(),
      ),
      GoRoute(
        path: AppRoutePaths.doctorsPage,
        name: AppRouteNames.doctorsPage,
        builder: (context, state) => const DoctorsPage(),
      ),
      // GoRoute(
      //   path: AppRoutePaths.homePage,
      //   name: AppRouteNames.homePage,
      //   builder: (context, state) => const HomePage(),
      // ),
    ],
  );
}
