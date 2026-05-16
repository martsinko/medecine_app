import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class AppLocalizations {
  const AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = <Locale>[Locale('en'), Locale('uk')];

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static Locale resolveLocale(
    Locale? deviceLocale,
    Iterable<Locale> supportedLocales,
  ) {
    Locale resolvedLocale;

    if (deviceLocale == null) {
      resolvedLocale = supportedLocales.first;
    } else {
      resolvedLocale = const Locale('en');
      for (final locale in supportedLocales) {
        if (locale.languageCode == deviceLocale.languageCode) {
          resolvedLocale = locale;
          break;
        }
      }
    }

    Intl.defaultLocale = resolvedLocale.toLanguageTag();
    return resolvedLocale;
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static String currentText(String key, [Map<String, Object> args = const {}]) {
    final localeCode = Intl.defaultLocale?.split(RegExp('[-_]')).first ?? 'en';
    return AppLocalizations(Locale(localeCode)).text(key, args);
  }

  String text(String key, [Map<String, Object> args = const {}]) {
    final languageCode = locale.languageCode;
    var value =
        _localizedValues[languageCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;
    for (final entry in args.entries) {
      value = value.replaceAll('{${entry.key}}', entry.value.toString());
    }
    return value;
  }
}

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  String tr(String key, [Map<String, Object> args = const {}]) {
    return l10n.text(key, args);
  }

  String trError(Object error) {
    final message = error.toString();
    if (message.contains('wrong-password') ||
        message.contains('invalid-credential')) {
      return tr('wrongPassword');
    }
    if (message.contains('requires-recent-login')) {
      return tr('recentLoginRequired');
    }
    if (message.contains('No user logged in')) {
      return tr('noUserLoggedIn');
    }
    if (message.contains('password-provider-required')) {
      return tr('passwordProviderRequired');
    }
    if (message.contains('missing-email')) {
      return tr('missingEmail');
    }
    if (message.contains('unsupported-auth-provider')) {
      return tr('unsupportedAuthProvider');
    }
    if (message.contains('email-already-in-use')) {
      return tr('emailAlreadyInUse');
    }
    if (message.contains('user-not-found')) {
      return tr('userNotFound');
    }
    if (message.contains('weak-password')) {
      return tr('weakPassword');
    }
    return message.replaceFirst('Exception: ', '');
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales.any(
      (supportedLocale) => supportedLocale.languageCode == locale.languageCode,
    );
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

const Map<String, Map<String, String>> _localizedValues = {
  'en': {
    'appTitle': 'Medicity',
    'error': 'Error',
    'invalidTeacherSelection': 'Invalid teacher selection',
    'invalidAppointment': 'Invalid appointment',
    'welcomeTitle': 'DDPU \nConsultation',
    'welcomeSubtitle': 'DDPU',
    'welcomeDescription':
        'Book consultations with DDPU teachers, manage appointments, and keep your profile up to date in one place.',
    'login': 'Log In',
    'signUp': 'Sign Up',
    'welcome': 'Welcome',
    'emailOrPhone': 'Email or Mobile Number',
    'password': 'Password',
    'enterPassword': 'Enter your password',
    'forgotPassword': 'Forget Password',
    'dontHaveAccount': 'Don\'t have an account?',
    'newAccount': 'New Account',
    'fullName': 'Full Name',
    'enterFullName': 'Enter your full name',
    'mobileNumber': 'Mobile Number',
    'enterPhoneNumber': 'Enter your phone number',
    'dateOfBirth': 'Date of Birth',
    'email': 'Email',
    'alreadyHaveAccount': 'Already have an account?',
    'termsOfUse': 'Terms of Use',
    'privacyPolicy': 'Privacy Policy',
    'byContinuing': 'By continuing, you agree to ',
    'and': 'and',
    'setPassword': 'Set Password',
    'createNewPassword': 'Create new password',
    'confirmPassword': 'Confirm Password',
    'welcomeBack': 'Hi, Welcome Back',
    'teachers': 'Teachers',
    'favorite': 'Favorite',
    'profile': 'Profile',
    'myProfile': 'My Profile',
    'settings': 'Settings',
    'help': 'Help',
    'logout': 'Logout',
    'cancel': 'Cancel',
    'yesLogout': 'Yes, Logout',
    'logoutQuestion': 'Are you sure you want to log out?',
    'profilePhotoUpdated': 'Profile photo updated.',
    'profileUpdated': 'Profile updated.',
    'phoneNumber': 'Phone Number',
    'dateOfBirthDisplay': 'Date Of Birth',
    'updateProfile': 'Update Profile',
    'notificationSetting': 'Notification Setting',
    'passwordManager': 'Password Manager',
    'changePassword': 'Change your password',
    'changePasswordDescription':
        'Enter your current password and create a new one',
    'newPassword': 'New Password',
    'updatePassword': 'Update Password',
    'pleaseFillPasswordFields': 'Please fill in all password fields',
    'passwordTooShort': 'Password must be at least 6 characters',
    'passwordsDoNotMatch': 'Passwords do not match',
    'passwordUpdated': 'Password updated successfully.',
    'passwordCreated': 'Password created.',
    'deleteAccount': 'Delete Account',
    'generalNotification': 'General Notification',
    'sound': 'Sound',
    'soundCall': 'Sound Call',
    'vibrate': 'Vibrate',
    'specialOffers': 'Special Offers',
    'promoAndDiscount': 'Promo And Discount',
    'helpCenter': 'Help Center',
    'howCanWeHelp': 'How Can We Help You?',
    'search': 'Search...',
    'faq': 'FAQ',
    'contactUs': 'Contact Us',
    'popularTopic': 'Popular Topic',
    'general': 'General',
    'services': 'Services',
    'customerService': 'Customer Service',
    'website': 'Website',
    'whatsapp': 'Whatsapp',
    'facebook': 'Facebook',
    'instagram': 'Instagram',
    'lastUpdate': 'Last Update: 14/08/2024',
    'termsAndConditions': 'Terms & Conditions',
    'faqPrepareTitle': 'How do I prepare for a consultation?',
    'faqPrepareBody':
        'Review the teacher profile, choose a topic, and describe your question clearly before booking. This helps the teacher prepare practical guidance for your session.',
    'faqAppointmentTitle': 'How do I make an appointment?',
    'faqAppointmentBody':
        'Open a teacher card, review the available schedule, and confirm a suitable time slot. You can return later to reschedule from your profile.',
    'faqFavoriteTitle': 'Can I save favorite teachers?',
    'faqFavoriteBody':
        'Yes. Tap the favorite icon on a teacher card or in teacher details. Saved teachers appear in the Favorite section together with saved programming services.',
    'faqNotificationsTitle': 'How do notifications work?',
    'faqNotificationsBody':
        'Notification preferences can be adjusted from Settings. You can independently enable reminders, promo offers, and special offer messages.',
    'faqSupportTitle': 'What if I need support quickly?',
    'faqSupportBody':
        'Use the Contact Us tab in Help Center to reach customer service, website support, WhatsApp, Facebook, or Instagram.',
    'faqEditProfileTitle': 'How can I edit my profile?',
    'faqEditProfileBody':
        'Go to My Profile, tap Profile, update your information, and press Update Profile. The changes are reflected immediately in the profile section.',
    'privacyParagraph1':
        'We collect only the information needed to create your account, display your profile, save favorite teachers, and manage consultation bookings. This may include your name, email, phone number, profile photo, appointment details, and selected notification preferences.',
    'privacyParagraph2':
        'Your data is stored in Firebase services configured for this application. Profile and appointment information is used to provide the core consultation flow and is not intended for unrelated advertising or third-party resale.',
    'privacyTerm1':
        'Use the application only for valid educational consultations, profile management, and appointment coordination. Do not create bookings with false personal information or misuse another user account.',
    'privacyTerm2':
        'Appointment availability depends on teacher schedules stored in Firebase. A booking is considered active only after it is saved successfully and shown in the appointment list.',
    'privacyTerm3':
        'You can update your profile fields and notification preferences from the profile section. If account deletion is enabled for your user, related profile data can be removed according to the app flow.',
    'privacyTerm4':
        'The application may be updated to improve security, usability, Firebase integration, and appointment workflows. Continued use means you accept the current version of these terms.',
    'sortBy': 'Sort By',
    'az': 'A - Z',
    'rating': 'Rating',
    'male': 'Male',
    'female': 'Female',
    'other': 'Other',
    'favoriteMale': 'Favorite Male',
    'favoriteFemale': 'Favorite Female',
    'teacherInfo': 'Teacher Info',
    'teacherNotFound': 'Teacher not found',
    'profileSection': 'Profile',
    'careerPath': 'Career Path',
    'highlights': 'Highlights',
    'schedule': 'Schedule',
    'info': 'Info',
    'professionalTeacher': 'Professional Teacher',
    'yearsExperience': '{years} years\nexperience',
    'focusPrefix': 'Focus: ',
    'reviewsCount': '{count} reviews',
    'noTeachersMatchFilters': 'No teachers match selected filters.',
    'failedLoadTeachers': 'Failed to load teachers.',
    'noTeachersFound': 'No teachers found.',
    'unknown': 'Unknown',
    'guest': 'Guest',
    'eventTeacherOlivia': 'Olivia Turner',
    'eventProgrammingConsultation':
        'Programming consultation and practical task review.',
    'failedLoadFavorites': 'Failed to load favorites.',
    'failedLoadProfile': 'Failed to load profile.',
    'failedLoadRatings': 'Failed to load ratings.',
    'findProgrammingTeacher': 'Find a programming teacher',
    'serviceDebuggingTitle': 'Code Debugging',
    'serviceDebuggingDescription':
        'Root-cause analysis for bugs, stack trace review, and fixes for runtime, build, Flutter, Firebase, and backend integration issues.',
    'serviceReviewTitle': 'Code Review',
    'serviceReviewDescription':
        'A practical review of architecture, Riverpod logic, navigation, UI components, and code quality with concrete improvement notes.',
    'serviceArchitectureTitle': 'Flutter Architecture',
    'serviceArchitectureDescription':
        'Designing a clean structure for features, models, repositories, providers, and routes so the Flutter app stays scalable.',
    'serviceFirebaseTitle': 'Firebase & Riverpod',
    'serviceFirebaseDescription':
        'Auth, Firestore, CRUD flows, live data streams, and Riverpod state management without duplicated business logic.',
    'serviceAlgorithmsTitle': 'Algorithms & Tasks',
    'serviceAlgorithmsDescription':
        'Clear explanations of algorithms, data structures, practical coding tasks, and step-by-step breakdowns of complex solutions.',
    'teacherOliviaSpecialty': 'Flutter & Firebase',
    'teacherOliviaAvailability': 'Mon-Sat / 8:30 AM - 4:30 PM',
    'teacherOliviaFocus':
        'Specializes in Flutter architecture, Firebase integration, Riverpod state management, and production-ready mobile workflows.',
    'teacherOliviaProfile':
        'Olivia Turner helps students and junior developers build clean Flutter apps with reliable data flows, readable widgets, and maintainable feature structure.',
    'teacherOliviaCareer':
        'She moved from mobile UI implementation into full-cycle Flutter mentoring with a strong focus on Firebase-backed applications.',
    'teacherOliviaHighlights':
        'Known for practical explanations, clear refactoring examples, and step-by-step guidance through auth, Firestore, routing, and Riverpod.',
    'teacherAlexanderSpecialty': 'Debugging & Architecture',
    'teacherAlexanderAvailability': 'Mon-Sat / 9:00 AM - 5:00 PM',
    'teacherAlexanderFocus':
        'Finding root causes in complex bugs, improving app architecture, and turning fragile code into predictable modules.',
    'teacherAlexanderProfile':
        'Alexander Bennett works with Flutter teams to debug crashes, navigation issues, async state bugs, and hard-to-read legacy screens.',
    'teacherAlexanderCareer':
        'His engineering background led from app delivery to architecture reviews, mentoring, and technical troubleshooting sessions.',
    'teacherAlexanderHighlights':
        'Combines careful diagnosis with actionable code changes and is often consulted for go_router, provider, and build pipeline problems.',
    'teacherSophiaSpecialty': 'Code Review',
    'teacherSophiaAvailability': 'Tue-Sat / 10:00 AM - 6:00 PM',
    'teacherSophiaFocus':
        'Reviews Flutter features for readability, state boundaries, component reuse, testability, and long-term maintainability.',
    'teacherSophiaProfile':
        'Sophia Martinez helps developers understand why code feels hard to change and how to improve it without overengineering.',
    'teacherSophiaCareer':
        'After years of feature work, she specialized in code review, refactoring strategy, and team-level Flutter conventions.',
    'teacherSophiaHighlights':
        'Students value her concrete pull-request feedback, naming improvements, widget decomposition, and pragmatic testing advice.',
    'teacherMichaelSpecialty': 'Algorithms & Performance',
    'teacherMichaelAvailability': 'Mon-Fri / 9:30 AM - 4:00 PM',
    'teacherMichaelFocus':
        'Explains algorithms, data structures, performance bottlenecks, and practical optimization for app-level problems.',
    'teacherMichaelProfile':
        'Michael Davidson focuses on making complex programming concepts understandable through examples, visual reasoning, and small exercises.',
    'teacherMichaelCareer':
        'He has taught programming fundamentals, algorithmic thinking, and performance profiling for mobile and backend projects.',
    'teacherMichaelHighlights':
        'Provides practical strategies for problem solving, Big-O reasoning, profiling slow screens, and choosing simpler implementations.',
    'allAppointment': 'All Appointment',
    'complete': 'Complete',
    'upcoming': 'Upcoming',
    'cancelled': 'Cancelled',
    'details': 'Details',
    'reBook': 'Re-Book',
    'addReview': 'Add Review',
    'review': 'Review',
    'yourAppointment': 'Your Appointment',
    'bookingFor': 'Booking For',
    'yourself': 'Yourself',
    'anotherPerson': 'Another Person',
    'age': 'Age',
    'gender': 'Gender',
    'problem': 'Problem',
    'availableTime': 'Available Time',
    'patientDetails': 'Patient Details',
    'describeProblem': 'Describe your problem',
    'enterProblem': 'Enter Your Problem Here...',
    'continue': 'Continue',
    'booked': 'booked',
    'cancelAppointment': 'Cancel Appointment',
    'cancelAppointmentDescription':
        'Select the main reason for cancelling this consultation. Your response helps keep teacher availability accurate and improves future scheduling.',
    'cancelAppointmentNote':
        'Add a short note if the teacher or support team needs extra context about the cancellation.',
    'rescheduling': 'Rescheduling',
    'weatherConditions': 'Weather Conditions',
    'unexpectedWork': 'Unexpected Work',
    'others': 'Others',
    'enterReason': 'Enter Your Reason Here....',
    'reviewDescription':
        'Share how useful the consultation was. Your review helps other students choose the right teacher and helps improve future sessions.',
    'enterComment': 'Enter Your Comment Here...',
    'failedLoadTeacher': 'Failed to load teacher.',
    'failedLoadAppointment': 'Failed to load appointment.',
    'failedLoadAppointments': 'Failed to load appointments.',
    'defaultProblemDescription':
        'The student wants to clarify the topic, review practical examples, and receive recommendations for the next steps after the consultation.',
    'pleaseEnterPatientName': 'Please enter patient name',
    'pleaseEnterValidAge': 'Please enter a valid age',
    'pleaseSelectTimeSlot': 'Please select a time slot',
    'deleteAccountWarning':
        'This will permanently delete your profile and appointments.',
    'currentPassword': 'Current Password',
    'enterCurrentPassword': 'Please enter your current password.',
    'socialAccountConfirm': 'You will be asked to confirm your social account.',
    'delete': 'Delete',
    'accountDeleted': 'Account deleted successfully.',
    'wrongPassword': 'The current password is incorrect.',
    'recentLoginRequired': 'Please sign in again before deleting your account.',
    'googleCancelled': 'Google confirmation was cancelled.',
    'facebookCancelled': 'Facebook confirmation was cancelled.',
    'noUserLoggedIn': 'No user logged in.',
    'passwordProviderRequired':
        'This account is not using email and password authentication.',
    'missingEmail': 'This account does not have an email address.',
    'unsupportedAuthProvider':
        'This account provider is not supported for this action.',
    'emailAlreadyInUse': 'This email is already in use.',
    'userNotFound': 'User not found.',
    'weakPassword': 'Password is too weak.',
  },
  'uk': {
    'appTitle': 'Medicity',
    'error': 'Помилка',
    'invalidTeacherSelection': 'Некоректний вибір викладача',
    'invalidAppointment': 'Некоректний запис',
    'welcomeTitle': 'DDPU \nКонсультації',
    'welcomeSubtitle': 'ДДПУ',
    'welcomeDescription':
        'Записуйтеся на консультації до викладачів ДДПУ, керуйте зустрічами та оновлюйте профіль в одному застосунку.',
    'login': 'Увійти',
    'signUp': 'Зареєструватися',
    'welcome': 'Вітаємо',
    'emailOrPhone': 'Email або номер телефону',
    'password': 'Пароль',
    'enterPassword': 'Введіть пароль',
    'forgotPassword': 'Забули пароль',
    'dontHaveAccount': 'Немає акаунта?',
    'newAccount': 'Новий акаунт',
    'fullName': 'Повне імʼя',
    'enterFullName': 'Введіть повне імʼя',
    'mobileNumber': 'Номер телефону',
    'enterPhoneNumber': 'Введіть номер телефону',
    'dateOfBirth': 'Дата народження',
    'email': 'Email',
    'alreadyHaveAccount': 'Вже маєте акаунт?',
    'termsOfUse': 'Умови використання',
    'privacyPolicy': 'Політика конфіденційності',
    'byContinuing': 'Продовжуючи, ви погоджуєтесь з ',
    'and': 'та',
    'setPassword': 'Встановити пароль',
    'createNewPassword': 'Створити новий пароль',
    'confirmPassword': 'Підтвердіть пароль',
    'welcomeBack': 'Вітаємо знову',
    'teachers': 'Викладачі',
    'favorite': 'Улюблені',
    'profile': 'Профіль',
    'myProfile': 'Мій профіль',
    'settings': 'Налаштування',
    'help': 'Допомога',
    'logout': 'Вийти',
    'cancel': 'Скасувати',
    'yesLogout': 'Так, вийти',
    'logoutQuestion': 'Ви впевнені, що хочете вийти?',
    'profilePhotoUpdated': 'Фото профілю оновлено.',
    'profileUpdated': 'Профіль оновлено.',
    'phoneNumber': 'Номер телефону',
    'dateOfBirthDisplay': 'Дата народження',
    'updateProfile': 'Оновити профіль',
    'notificationSetting': 'Налаштування сповіщень',
    'passwordManager': 'Менеджер пароля',
    'changePassword': 'Змінити пароль',
    'changePasswordDescription': 'Введіть поточний пароль і створіть новий',
    'newPassword': 'Новий пароль',
    'updatePassword': 'Оновити пароль',
    'pleaseFillPasswordFields': 'Заповніть усі поля пароля',
    'passwordTooShort': 'Пароль має містити щонайменше 6 символів',
    'passwordsDoNotMatch': 'Паролі не збігаються',
    'passwordUpdated': 'Пароль успішно оновлено.',
    'passwordCreated': 'Пароль створено.',
    'deleteAccount': 'Видалити акаунт',
    'generalNotification': 'Загальні сповіщення',
    'sound': 'Звук',
    'soundCall': 'Звук дзвінка',
    'vibrate': 'Вібрація',
    'specialOffers': 'Спеціальні пропозиції',
    'promoAndDiscount': 'Промо та знижки',
    'helpCenter': 'Центр допомоги',
    'howCanWeHelp': 'Як ми можемо допомогти?',
    'search': 'Пошук...',
    'faq': 'FAQ',
    'contactUs': 'Звʼязатися',
    'popularTopic': 'Популярне',
    'general': 'Загальне',
    'services': 'Сервіси',
    'customerService': 'Підтримка',
    'website': 'Вебсайт',
    'whatsapp': 'Whatsapp',
    'facebook': 'Facebook',
    'instagram': 'Instagram',
    'lastUpdate': 'Останнє оновлення: 14/08/2024',
    'termsAndConditions': 'Умови та положення',
    'faqPrepareTitle': 'Як підготуватися до консультації?',
    'faqPrepareBody':
        'Перегляньте профіль викладача, оберіть тему та коротко опишіть запит перед бронюванням. Це допоможе викладачу підготувати практичні поради для зустрічі.',
    'faqAppointmentTitle': 'Як записатися на консультацію?',
    'faqAppointmentBody':
        'Відкрийте картку викладача, перегляньте доступний графік і підтвердьте зручний час. Пізніше ви можете змінити запис у профілі.',
    'faqFavoriteTitle': 'Чи можна зберігати улюблених викладачів?',
    'faqFavoriteBody':
        'Так. Натисніть іконку серця на картці викладача або в деталях. Збережені викладачі будуть у розділі Улюблені разом із сервісами програмування.',
    'faqNotificationsTitle': 'Як працюють сповіщення?',
    'faqNotificationsBody':
        'Налаштування сповіщень можна змінити в розділі Налаштування. Ви можете окремо керувати нагадуваннями, промо та спеціальними пропозиціями.',
    'faqSupportTitle': 'Що робити, якщо потрібна швидка допомога?',
    'faqSupportBody':
        'Використайте вкладку Звʼязатися в центрі допомоги, щоб перейти до підтримки, сайту або соціальних каналів.',
    'faqEditProfileTitle': 'Як редагувати профіль?',
    'faqEditProfileBody':
        'Перейдіть у Мій профіль, натисніть Профіль, оновіть дані та натисніть Оновити профіль. Зміни одразу відображаються у профілі.',
    'privacyParagraph1':
        'Ми збираємо лише дані, потрібні для створення акаунта, відображення профілю, збереження улюблених викладачів і керування записами на консультації. Це може включати імʼя, email, номер телефону, фото профілю, дані записів і налаштування сповіщень.',
    'privacyParagraph2':
        'Ваші дані зберігаються у Firebase-сервісах, налаштованих для цього застосунку. Інформація профілю та записів використовується для роботи консультаційного сценарію і не призначена для стороннього продажу.',
    'privacyTerm1':
        'Використовуйте застосунок лише для навчальних консультацій, керування профілем і записами. Не створюйте записи з неправдивими персональними даними та не використовуйте чужий акаунт.',
    'privacyTerm2':
        'Доступність консультацій залежить від графіків викладачів у Firebase. Запис активний лише після успішного збереження і появи у списку записів.',
    'privacyTerm3':
        'Ви можете оновлювати поля профілю та налаштування сповіщень у профілі. Якщо для користувача доступне видалення акаунта, повʼязані дані можуть бути видалені через відповідний сценарій.',
    'privacyTerm4':
        'Застосунок може оновлюватися для покращення безпеки, зручності, Firebase-інтеграції та записів. Подальше використання означає згоду з поточною версією умов.',
    'sortBy': 'Сортувати',
    'az': 'А - Я',
    'rating': 'Рейтинг',
    'male': 'Чоловіки',
    'female': 'Жінки',
    'other': 'Інше',
    'favoriteMale': 'Улюблені чоловіки',
    'favoriteFemale': 'Улюблені жінки',
    'teacherInfo': 'Інформація',
    'teacherNotFound': 'Викладача не знайдено',
    'profileSection': 'Профіль',
    'careerPath': 'Карʼєрний шлях',
    'highlights': 'Досягнення',
    'schedule': 'Графік',
    'info': 'Інфо',
    'professionalTeacher': 'Професійний викладач',
    'yearsExperience': '{years} років\nдосвіду',
    'focusPrefix': 'Фокус: ',
    'reviewsCount': '{count} відгуків',
    'noTeachersMatchFilters': 'Немає викладачів за вибраними фільтрами.',
    'failedLoadTeachers': 'Не вдалося завантажити викладачів.',
    'noTeachersFound': 'Викладачів не знайдено.',
    'unknown': 'Невідомо',
    'guest': 'Гість',
    'eventTeacherOlivia': 'Олівія Тернер',
    'eventProgrammingConsultation':
        'Консультація з програмування та розбір практичного завдання.',
    'failedLoadFavorites': 'Не вдалося завантажити улюблені.',
    'failedLoadProfile': 'Не вдалося завантажити профіль.',
    'failedLoadRatings': 'Не вдалося завантажити рейтинг.',
    'findProgrammingTeacher': 'Знайти викладача з програмування',
    'serviceDebuggingTitle': 'Дебагінг коду',
    'serviceDebuggingDescription':
        'Пошук причин багів, аналіз stack trace та виправлення runtime, build, Flutter, Firebase і backend-інтеграцій.',
    'serviceReviewTitle': 'Код-ревʼю',
    'serviceReviewDescription':
        'Практичний перегляд архітектури, Riverpod-логіки, навігації, UI-компонентів і якості коду з конкретними порадами.',
    'serviceArchitectureTitle': 'Flutter-архітектура',
    'serviceArchitectureDescription':
        'Проєктування чистої структури features, models, repositories, providers і routes, щоб застосунок залишався масштабованим.',
    'serviceFirebaseTitle': 'Firebase та Riverpod',
    'serviceFirebaseDescription':
        'Auth, Firestore, CRUD-сценарії, live streams і Riverpod state management без дублювання бізнес-логіки.',
    'serviceAlgorithmsTitle': 'Алгоритми та задачі',
    'serviceAlgorithmsDescription':
        'Зрозумілі пояснення алгоритмів, структур даних, практичних задач і покроковий розбір складних рішень.',
    'teacherOliviaSpecialty': 'Flutter та Firebase',
    'teacherOliviaAvailability': 'Пн-Сб / 08:30 - 16:30',
    'teacherOliviaFocus':
        'Спеціалізується на Flutter-архітектурі, Firebase-інтеграції, Riverpod state management і production-ready мобільних процесах.',
    'teacherOliviaProfile':
        'Олівія Тернер допомагає студентам і junior-розробникам будувати чисті Flutter-застосунки з надійними потоками даних, читабельними віджетами та підтримуваною структурою features.',
    'teacherOliviaCareer':
        'Вона перейшла від реалізації mobile UI до повного Flutter-менторства з фокусом на Firebase-backed застосунки.',
    'teacherOliviaHighlights':
        'Відома практичними поясненнями, зрозумілими прикладами рефакторингу та покроковою допомогою з auth, Firestore, routing і Riverpod.',
    'teacherAlexanderSpecialty': 'Дебагінг та архітектура',
    'teacherAlexanderAvailability': 'Пн-Сб / 09:00 - 17:00',
    'teacherAlexanderFocus':
        'Пошук причин складних багів, покращення архітектури застосунку та перетворення крихкого коду на передбачувані модулі.',
    'teacherAlexanderProfile':
        'Александр Беннетт допомагає Flutter-командам розбирати crashes, проблеми навігації, async state bugs і складні legacy-екрани.',
    'teacherAlexanderCareer':
        'Його інженерний шлях перейшов від delivery застосунків до architecture review, менторства та технічного troubleshooting.',
    'teacherAlexanderHighlights':
        'Поєднує уважну діагностику з конкретними правками коду й часто консультує щодо go_router, provider та build pipeline.',
    'teacherSophiaSpecialty': 'Код-ревʼю',
    'teacherSophiaAvailability': 'Вт-Сб / 10:00 - 18:00',
    'teacherSophiaFocus':
        'Перевіряє Flutter-features на читабельність, межі state, повторне використання компонентів, тестованість і підтримуваність.',
    'teacherSophiaProfile':
        'Софія Мартінез допомагає розробникам зрозуміти, чому код важко змінювати, і як покращити його без overengineering.',
    'teacherSophiaCareer':
        'Після років feature work вона спеціалізувалася на code review, стратегії рефакторингу та командних Flutter-конвенціях.',
    'teacherSophiaHighlights':
        'Студенти цінують її конкретний pull-request feedback, покращення naming, декомпозицію віджетів і прагматичні поради з тестування.',
    'teacherMichaelSpecialty': 'Алгоритми та продуктивність',
    'teacherMichaelAvailability': 'Пн-Пт / 09:30 - 16:00',
    'teacherMichaelFocus':
        'Пояснює алгоритми, структури даних, bottlenecks продуктивності та практичну оптимізацію для app-level задач.',
    'teacherMichaelProfile':
        'Майкл Девідсон робить складні концепції програмування зрозумілими через приклади, візуальне мислення та невеликі вправи.',
    'teacherMichaelCareer':
        'Викладав основи програмування, алгоритмічне мислення та profiling для mobile і backend-проєктів.',
    'teacherMichaelHighlights':
        'Дає практичні стратегії problem solving, Big-O reasoning, profiling повільних екранів і вибору простіших реалізацій.',
    'allAppointment': 'Усі записи',
    'complete': 'Завершені',
    'upcoming': 'Майбутні',
    'cancelled': 'Скасовані',
    'details': 'Деталі',
    'reBook': 'Записатися знову',
    'addReview': 'Додати відгук',
    'review': 'Відгук',
    'yourAppointment': 'Ваш запис',
    'bookingFor': 'Запис для',
    'yourself': 'Себе',
    'anotherPerson': 'Іншої людини',
    'age': 'Вік',
    'gender': 'Стать',
    'problem': 'Питання',
    'availableTime': 'Доступний час',
    'patientDetails': 'Дані студента',
    'describeProblem': 'Опишіть питання',
    'enterProblem': 'Введіть ваше питання...',
    'continue': 'Продовжити',
    'booked': 'зайнято',
    'cancelAppointment': 'Скасувати запис',
    'cancelAppointmentDescription':
        'Оберіть основну причину скасування консультації. Відповідь допоможе підтримувати актуальний графік викладачів.',
    'cancelAppointmentNote':
        'Додайте короткий коментар, якщо викладачу або підтримці потрібен додатковий контекст.',
    'rescheduling': 'Перенесення',
    'weatherConditions': 'Погодні умови',
    'unexpectedWork': 'Непередбачена зайнятість',
    'others': 'Інше',
    'enterReason': 'Введіть причину...',
    'reviewDescription':
        'Поділіться, наскільки корисною була консультація. Ваш відгук допоможе іншим студентам обрати викладача.',
    'enterComment': 'Введіть коментар...',
    'failedLoadTeacher': 'Не вдалося завантажити викладача.',
    'failedLoadAppointment': 'Не вдалося завантажити запис.',
    'failedLoadAppointments': 'Не вдалося завантажити записи.',
    'defaultProblemDescription':
        'Студент хоче уточнити тему, розібрати практичні приклади та отримати рекомендації щодо наступних кроків після консультації.',
    'pleaseEnterPatientName': 'Введіть імʼя студента',
    'pleaseEnterValidAge': 'Введіть коректний вік',
    'pleaseSelectTimeSlot': 'Оберіть часовий слот',
    'deleteAccountWarning': 'Це назавжди видалить ваш профіль і записи.',
    'currentPassword': 'Поточний пароль',
    'enterCurrentPassword': 'Введіть поточний пароль.',
    'socialAccountConfirm': 'Потрібно буде підтвердити соціальний акаунт.',
    'delete': 'Видалити',
    'accountDeleted': 'Акаунт успішно видалено.',
    'wrongPassword': 'Поточний пароль неправильний.',
    'recentLoginRequired': 'Увійдіть повторно перед видаленням акаунта.',
    'googleCancelled': 'Підтвердження Google скасовано.',
    'facebookCancelled': 'Підтвердження Facebook скасовано.',
    'noUserLoggedIn': 'Користувач не увійшов.',
    'passwordProviderRequired':
        'Цей акаунт не використовує вхід через email і пароль.',
    'missingEmail': 'У цього акаунта немає email-адреси.',
    'unsupportedAuthProvider':
        'Провайдер цього акаунта не підтримується для цієї дії.',
    'emailAlreadyInUse': 'Цей email вже використовується.',
    'userNotFound': 'Користувача не знайдено.',
    'weakPassword': 'Пароль занадто слабкий.',
  },
};
