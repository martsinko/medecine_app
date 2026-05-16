import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medicity_app/core/constants/app_routes.dart';
import 'package:medicity_app/core/firebase/firebase_providers.dart';
import 'package:medicity_app/core/localization/app_localizations.dart';
import 'package:medicity_app/features/appointment/presentation/screens/appointment_details_page.dart';
import 'package:medicity_app/features/appointment/presentation/screens/appointments_page.dart';
import 'package:medicity_app/features/appointment/presentation/screens/cancel_appointment_page.dart';
import 'package:medicity_app/features/appointment/presentation/screens/review_appointment_page.dart';
import 'package:medicity_app/features/appointment/presentation/screens/schedule_doctor_page.dart';
import 'package:medicity_app/features/appointment/presentation/screens/schedule_form_page.dart';
import 'package:medicity_app/features/auth/presentation/screens/log_in_page.dart';
import 'package:medicity_app/features/entry/presentation/screens/splash_screen.dart';
import 'package:medicity_app/features/entry/presentation/screens/welcome_screen.dart';
import 'package:medicity_app/features/home/presentation/screens/doctor_info_page.dart';
import 'package:medicity_app/features/home/presentation/screens/home_page.dart';
import 'package:medicity_app/features/home/presentation/screens/rating_page.dart';
import 'package:medicity_app/features/profile/presentation/screens/edit_profile_page.dart';
import 'package:medicity_app/features/profile/presentation/screens/help_center_page.dart';
import 'package:medicity_app/features/profile/presentation/screens/notification_settings_page.dart';
import 'package:medicity_app/features/profile/presentation/screens/privacy_policy_page.dart';
import 'package:medicity_app/features/profile/presentation/screens/profile_page.dart';
import 'package:medicity_app/features/profile/presentation/screens/settings_page.dart';
import '../../features/auth/presentation/screens/set_password_page.dart';
import '../../features/auth/presentation/screens/sign_up_page.dart';
import '../../features/home/presentation/screens/teachers_page.dart';
import '../../features/home/presentation/screens/favorite_page.dart';
import '../../shared/widgets/custom_bottom_nav_bar.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final GoRouter router = GoRouter(
    debugLogDiagnostics: kDebugMode,
    initialLocation: AppRoutePaths.splashScreen,
    redirect: (context, state) {
      final container = ProviderScope.containerOf(context);
      final authUser = container.read(authStateChangesProvider).value;
      final isLoggedIn = authUser != null;

      final loggingIn =
          state.matchedLocation == AppRoutePaths.loginPage ||
          state.matchedLocation == AppRoutePaths.welcomePage ||
          state.matchedLocation == AppRoutePaths.signUpPage ||
          state.matchedLocation == AppRoutePaths.splashScreen;

      if (!isLoggedIn && !loggingIn) {
        return null;
      }

      if (isLoggedIn && loggingIn) {
        return AppRoutePaths.homePage;
      }

      return null;
    },
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
              return const HomePage();
            },
          ),
          GoRoute(
            path: AppRoutePaths.teachersPage,
            name: AppRouteNames.teachersPage,
            builder: (context, state) {
              return const TeachersPage();
            },
          ),
          GoRoute(
            path: AppRoutePaths.teacherInfoPage,
            name: AppRouteNames.teacherInfoPage,
            builder: (context, state) {
              final teacherId = state.pathParameters['teacherId'];
              if (teacherId == null || teacherId.isEmpty) {
                return Scaffold(
                  appBar: AppBar(title: Text(context.tr('error'))),
                  body: Center(
                    child: Text(context.tr('invalidTeacherSelection')),
                  ),
                );
              }
              return DoctorInfoPage(teacherId: teacherId);
            },
          ),
          GoRoute(
            path: AppRoutePaths.ratingPage,
            name: AppRouteNames.ratingPage,
            builder: (context, state) {
              return const RatingPage();
            },
          ),
          GoRoute(
            path: AppRoutePaths.wishlistPage,
            name: AppRouteNames.wishlistPage,
            builder: (context, state) {
              return const FavoritePage();
            },
          ),
          GoRoute(
            path: AppRoutePaths.profilePage,
            name: AppRouteNames.profilePage,
            builder: (context, state) {
              return const ProfilePage();
            },
          ),
          GoRoute(
            path: AppRoutePaths.appointmentsPage,
            name: AppRouteNames.appointmentsPage,
            builder: (context, state) {
              final tab = state.uri.queryParameters['tab'];
              return AppointmentsPage(
                initialStatus: appointmentStatusFromQuery(tab),
              );
            },
          ),
          GoRoute(
            path: AppRoutePaths.scheduleTeacherPage,
            name: AppRouteNames.scheduleTeacherPage,
            builder: (context, state) {
              final teacherId = state.pathParameters['teacherId'];
              if (teacherId == null || teacherId.isEmpty) {
                return Scaffold(
                  appBar: AppBar(title: Text(context.tr('error'))),
                  body: Center(
                    child: Text(context.tr('invalidTeacherSelection')),
                  ),
                );
              }
              return ScheduleDoctorPage(doctorId: teacherId);
            },
          ),
          GoRoute(
            path: AppRoutePaths.scheduleFormPage,
            name: AppRouteNames.scheduleFormPage,
            builder: (context, state) {
              final teacherId = state.pathParameters['teacherId'];
              if (teacherId == null || teacherId.isEmpty) {
                return Scaffold(
                  appBar: AppBar(title: Text(context.tr('error'))),
                  body: Center(
                    child: Text(context.tr('invalidTeacherSelection')),
                  ),
                );
              }
              return ScheduleFormPage(doctorId: teacherId);
            },
          ),
          GoRoute(
            path: AppRoutePaths.appointmentDetailsPage,
            name: AppRouteNames.appointmentDetailsPage,
            builder: (context, state) {
              final appointmentId = state.pathParameters['appointmentId'];
              if (appointmentId == null || appointmentId.isEmpty) {
                return Scaffold(
                  appBar: AppBar(title: Text(context.tr('error'))),
                  body: Center(child: Text(context.tr('invalidAppointment'))),
                );
              }
              return AppointmentDetailsPage(appointmentId: appointmentId);
            },
          ),
          GoRoute(
            path: AppRoutePaths.cancelAppointmentPage,
            name: AppRouteNames.cancelAppointmentPage,
            builder: (context, state) {
              final appointmentId = state.pathParameters['appointmentId'];
              if (appointmentId == null || appointmentId.isEmpty) {
                return Scaffold(
                  appBar: AppBar(title: Text(context.tr('error'))),
                  body: Center(child: Text(context.tr('invalidAppointment'))),
                );
              }
              return CancelAppointmentPage(appointmentId: appointmentId);
            },
          ),
          GoRoute(
            path: AppRoutePaths.reviewAppointmentPage,
            name: AppRouteNames.reviewAppointmentPage,
            builder: (context, state) {
              final appointmentId = state.pathParameters['appointmentId'];
              if (appointmentId == null || appointmentId.isEmpty) {
                return Scaffold(
                  appBar: AppBar(title: Text(context.tr('error'))),
                  body: Center(child: Text(context.tr('invalidAppointment'))),
                );
              }
              return ReviewAppointmentPage(appointmentId: appointmentId);
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
        builder: (context, state) {
          final isPasswordManager = state.extra as bool? ?? false;
          return SetPasswordPage(isPasswordManager: isPasswordManager);
        },
      ),
      GoRoute(
        path: AppRoutePaths.editProfilePage,
        name: AppRouteNames.editProfilePage,
        builder: (context, state) => const EditProfilePage(),
      ),
      GoRoute(
        path: AppRoutePaths.settingsPage,
        name: AppRouteNames.settingsPage,
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: AppRoutePaths.notificationSettingsPage,
        name: AppRouteNames.notificationSettingsPage,
        builder: (context, state) => const NotificationSettingsPage(),
      ),
      GoRoute(
        path: AppRoutePaths.privacyPolicyPage,
        name: AppRouteNames.privacyPolicyPage,
        builder: (context, state) => const PrivacyPolicyPage(),
      ),
      GoRoute(
        path: AppRoutePaths.helpCenterPage,
        name: AppRouteNames.helpCenterPage,
        builder: (context, state) => const HelpCenterPage(),
      ),
      // GoRoute(
      //   path: AppRoutePaths.homePage,
      //   name: AppRouteNames.homePage,
      //   builder: (context, state) => const HomePage(),
      // ),
    ],
  );
}
