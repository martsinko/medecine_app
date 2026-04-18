abstract final class AppRoutePaths {
  static const String splashScreen = '/splash';
  static const String welcomeScreen = '/welcome';
  static const String welcomePage = '/welcome';
  static const String loginPage = '/login';
  static const String signUpPage = '/signup';
  static const String setPassword = '/set_password';
  static const String homePage = '/home';
  static const String doctorsPage = '/doctors';
  static const String doctorInfoPage = '/doctors/:doctorId';
  static const String ratingPage = '/ratings';
  static const String wishlistPage = '/wishlist';
  static const String appointmentsPage = '/appointments';
  static const String scheduleDoctorPage = '/schedule/:doctorId';
  static const String scheduleFormPage = '/schedule/:doctorId/form';
  static const String appointmentDetailsPage =
      '/appointments/details/:appointmentId';
  static const String cancelAppointmentPage =
      '/appointments/cancel/:appointmentId';
  static const String reviewAppointmentPage =
      '/appointments/review/:appointmentId';
  static const String profilePage = '/profile';
  static const String editProfilePage = '/profile/edit';
  static const String settingsPage = '/settings';
  static const String notificationSettingsPage = '/settings/notifications';
  static const String privacyPolicyPage = '/privacy-policy';
  static const String helpCenterPage = '/help-center';
}

abstract final class AppRouteNames {
  static const String splashScreen = 'splash';
  static const String welcomeScreen = 'welcome';
  static const String loginPage = 'login';
  static const String signUpPage = 'signup';
  static const String setPassword = 'set_password';
  static const String doctorsPage = 'doctors';
  static const String doctorInfoPage = 'doctor_info';
  static const String ratingPage = 'ratings';
  static const String homePage = 'home';
  static const String wishlistPage = 'wishlist';
  static const String appointmentsPage = 'appointments';
  static const String scheduleDoctorPage = 'schedule_doctor';
  static const String scheduleFormPage = 'schedule_form';
  static const String appointmentDetailsPage = 'appointment_details';
  static const String cancelAppointmentPage = 'cancel_appointment';
  static const String reviewAppointmentPage = 'review_appointment';
  static const String profilePage = 'profile';
  static const String editProfilePage = 'edit_profile';
  static const String settingsPage = 'settings';
  static const String notificationSettingsPage = 'notification_settings';
  static const String privacyPolicyPage = 'privacy_policy';
  static const String helpCenterPage = 'help_center';
}
