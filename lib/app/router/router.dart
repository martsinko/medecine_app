import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medicity_app/core/constants/app_routes.dart';
import 'package:medicity_app/features/appointment/presentation/screens/appointment_details_page.dart';
import 'package:medicity_app/features/appointment/presentation/screens/appointments_page.dart';
import 'package:medicity_app/features/appointment/presentation/screens/cancel_appointment_page.dart';
import 'package:medicity_app/features/appointment/presentation/screens/review_appointment_page.dart';
import 'package:medicity_app/features/appointment/presentation/screens/schedule_doctor_page.dart';
import 'package:medicity_app/features/appointment/presentation/screens/schedule_form_page.dart';
import 'package:medicity_app/features/auth/presentation/screens/log_in_page.dart';
import 'package:medicity_app/features/entry/presentation/screens/splash_screen.dart';
import 'package:medicity_app/features/entry/presentation/screens/welcome_screen.dart';
import 'package:medicity_app/features/home/presentation/data/doctors_mock.dart';
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
import '../../features/home/presentation/screens/doctors_page.dart';
import '../../features/home/presentation/screens/favorite_page.dart';
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
              return const HomePage();
            },
          ),
          GoRoute(
            path: AppRoutePaths.doctorsPage,
            name: AppRouteNames.doctorsPage,
            builder: (context, state) {
              return const DoctorsPage();
            },
          ),
          GoRoute(
            path: AppRoutePaths.doctorInfoPage,
            name: AppRouteNames.doctorInfoPage,
            builder: (context, state) {
              final doctorId = state.pathParameters['doctorId'] ?? '';
              return DoctorInfoPage(doctor: getDoctorById(doctorId));
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
            path: AppRoutePaths.scheduleDoctorPage,
            name: AppRouteNames.scheduleDoctorPage,
            builder: (context, state) {
              final doctorId = state.pathParameters['doctorId'] ?? '';
              return ScheduleDoctorPage(doctorId: doctorId);
            },
          ),
          GoRoute(
            path: AppRoutePaths.scheduleFormPage,
            name: AppRouteNames.scheduleFormPage,
            builder: (context, state) {
              final doctorId = state.pathParameters['doctorId'] ?? '';
              return ScheduleFormPage(doctorId: doctorId);
            },
          ),
          GoRoute(
            path: AppRoutePaths.appointmentDetailsPage,
            name: AppRouteNames.appointmentDetailsPage,
            builder: (context, state) {
              final appointmentId = state.pathParameters['appointmentId'] ?? '';
              return AppointmentDetailsPage(appointmentId: appointmentId);
            },
          ),
          GoRoute(
            path: AppRoutePaths.cancelAppointmentPage,
            name: AppRouteNames.cancelAppointmentPage,
            builder: (context, state) {
              final appointmentId = state.pathParameters['appointmentId'] ?? '';
              return CancelAppointmentPage(appointmentId: appointmentId);
            },
          ),
          GoRoute(
            path: AppRoutePaths.reviewAppointmentPage,
            name: AppRouteNames.reviewAppointmentPage,
            builder: (context, state) {
              final appointmentId = state.pathParameters['appointmentId'] ?? '';
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
        builder: (context, state) => const SetPasswordPage(),
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
