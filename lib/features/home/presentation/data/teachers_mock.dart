import 'package:medicity_app/core/constants/app_images.dart';

import '../models/doctor_profile.dart';

final List<DoctorProfile> teachersMock = [
  DoctorProfile(
    id: 'olivia-turner',
    name: 'Olivia Turner',
    specialty: 'Flutter & Firebase',
    rating: 5.0,
    reviews: 54,
    experienceYears: 11,
    availability: 'Mon-Sat / 8:30AM - 4:30PM',
    imagePath: AppImages.exampleAvatar,
    focus:
        'Specializes in Flutter architecture, Firebase integration, Riverpod state management, and production-ready mobile workflows.',
    profile:
        'Olivia Turner helps students and junior developers build clean Flutter apps with reliable data flows, readable widgets, and maintainable feature structure.',
    careerPath:
        'She moved from mobile UI implementation into full-cycle Flutter mentoring with a strong focus on Firebase-backed applications.',
    highlights:
        'Known for practical explanations, clear refactoring examples, and step-by-step guidance through auth, Firestore, routing, and Riverpod.',
    isFavorite: true,
    gender: DoctorGender.female,
  ),
  DoctorProfile(
    id: 'alexander-bennett',
    name: 'Alexander Bennett',
    specialty: 'Debugging & Architecture',
    rating: 5.0,
    reviews: 40,
    experienceYears: 15,
    availability: 'Mon-Sat / 9:00AM - 5:00PM',
    imagePath: AppImages.tryAvatarImage,
    focus:
        'Focus: finding root causes in complex bugs, improving app architecture, and turning fragile code into predictable modules.',
    profile:
        'Alexander Bennett works with Flutter teams to debug crashes, navigation issues, async state bugs, and hard-to-read legacy screens.',
    careerPath:
        'His engineering background led from app delivery to architecture reviews, mentoring, and technical troubleshooting sessions.',
    highlights:
        'Combines careful diagnosis with actionable code changes and is often consulted for go_router, provider, and build pipeline problems.',
    isFavorite: true,
    gender: DoctorGender.male,
  ),
  DoctorProfile(
    id: 'sophia-martinez',
    name: 'Sophia Martinez',
    specialty: 'Code Review',
    rating: 4.9,
    reviews: 28,
    experienceYears: 9,
    availability: 'Tue-Sat / 10:00AM - 6:00PM',
    imagePath: AppImages.exampleAvatar,
    focus:
        'Reviews Flutter features for readability, state boundaries, component reuse, testability, and long-term maintainability.',
    profile:
        'Sophia Martinez helps developers understand why code feels hard to change and how to improve it without overengineering.',
    careerPath:
        'After years of feature work, she specialized in code review, refactoring strategy, and team-level Flutter conventions.',
    highlights:
        'Students value her concrete pull-request feedback, naming improvements, widget decomposition, and pragmatic testing advice.',
    isFavorite: true,
    gender: DoctorGender.female,
  ),
  DoctorProfile(
    id: 'michael-davidson',
    name: 'Michael Davidson',
    specialty: 'Algorithms & Performance',
    rating: 4.8,
    reviews: 32,
    experienceYears: 12,
    availability: 'Mon-Fri / 9:30AM - 4:00PM',
    imagePath: AppImages.tryAvatarImage,
    focus:
        'Explains algorithms, data structures, performance bottlenecks, and practical optimization for app-level problems.',
    profile:
        'Michael Davidson focuses on making complex programming concepts understandable through examples, visual reasoning, and small exercises.',
    careerPath:
        'He has taught programming fundamentals, algorithmic thinking, and performance profiling for mobile and backend projects.',
    highlights:
        'Provides practical strategies for problem solving, Big-O reasoning, profiling slow screens, and choosing simpler implementations.',
    isFavorite: true,
    gender: DoctorGender.male,
  ),
];

const List<FavoriteServiceCategory> favoriteServicesMock = [
  FavoriteServiceCategory(
    title: 'Code Debugging',
    description:
        'Root-cause analysis for bugs, stack trace review, and fixes for runtime, build, Flutter, Firebase, and backend integration issues.',
  ),
  FavoriteServiceCategory(
    title: 'Code Review',
    description:
        'A practical review of architecture, Riverpod logic, navigation, UI components, and code quality with concrete improvement notes.',
  ),
  FavoriteServiceCategory(
    title: 'Flutter Architecture',
    description:
        'Designing a clean structure for features, models, repositories, providers, and routes so the Flutter app stays scalable.',
  ),
  FavoriteServiceCategory(
    title: 'Firebase & Riverpod',
    description:
        'Auth, Firestore, CRUD flows, live data streams, and Riverpod state management without duplicated business logic.',
  ),
  FavoriteServiceCategory(
    title: 'Algorithms & Tasks',
    description:
        'Clear explanations of algorithms, data structures, practical coding tasks, and step-by-step breakdowns of complex solutions.',
  ),
];

DoctorProfile getDoctorById(String id) {
  return teachersMock.firstWhere(
    (doctor) => doctor.id == id,
    orElse: () => teachersMock.first,
  );
}

List<DoctorProfile> getFavoriteDoctorsByGender(DoctorGender? gender) {
  final favorites = teachersMock.where((doctor) => doctor.isFavorite);
  if (gender == null) {
    return favorites.toList();
  }

  return favorites.where((doctor) => doctor.gender == gender).toList();
}
