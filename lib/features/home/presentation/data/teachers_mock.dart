import 'package:medicity_app/core/constants/app_images.dart';

import '../models/doctor_profile.dart';

final List<DoctorProfile> teachersMock = [
  DoctorProfile(
    id: 'olivia-turner',
    name: 'Olivia Turner',
    specialty: 'teacherOliviaSpecialty',
    rating: 5.0,
    reviews: 54,
    experienceYears: 11,
    availability: 'teacherOliviaAvailability',
    imagePath: AppImages.exampleAvatar,
    focus: 'teacherOliviaFocus',
    profile: 'teacherOliviaProfile',
    careerPath: 'teacherOliviaCareer',
    highlights: 'teacherOliviaHighlights',
    isFavorite: true,
    gender: DoctorGender.female,
  ),
  DoctorProfile(
    id: 'alexander-bennett',
    name: 'Alexander Bennett',
    specialty: 'teacherAlexanderSpecialty',
    rating: 5.0,
    reviews: 40,
    experienceYears: 15,
    availability: 'teacherAlexanderAvailability',
    imagePath: AppImages.tryAvatarImage,
    focus: 'teacherAlexanderFocus',
    profile: 'teacherAlexanderProfile',
    careerPath: 'teacherAlexanderCareer',
    highlights: 'teacherAlexanderHighlights',
    isFavorite: true,
    gender: DoctorGender.male,
  ),
  DoctorProfile(
    id: 'sophia-martinez',
    name: 'Sophia Martinez',
    specialty: 'teacherSophiaSpecialty',
    rating: 4.9,
    reviews: 28,
    experienceYears: 9,
    availability: 'teacherSophiaAvailability',
    imagePath: AppImages.exampleAvatar,
    focus: 'teacherSophiaFocus',
    profile: 'teacherSophiaProfile',
    careerPath: 'teacherSophiaCareer',
    highlights: 'teacherSophiaHighlights',
    isFavorite: true,
    gender: DoctorGender.female,
  ),
  DoctorProfile(
    id: 'michael-davidson',
    name: 'Michael Davidson',
    specialty: 'teacherMichaelSpecialty',
    rating: 4.8,
    reviews: 32,
    experienceYears: 12,
    availability: 'teacherMichaelAvailability',
    imagePath: AppImages.tryAvatarImage,
    focus: 'teacherMichaelFocus',
    profile: 'teacherMichaelProfile',
    careerPath: 'teacherMichaelCareer',
    highlights: 'teacherMichaelHighlights',
    isFavorite: true,
    gender: DoctorGender.male,
  ),
];

const List<FavoriteServiceCategory> favoriteServicesMock = [
  FavoriteServiceCategory(
    title: 'serviceDebuggingTitle',
    description: 'serviceDebuggingDescription',
  ),
  FavoriteServiceCategory(
    title: 'serviceReviewTitle',
    description: 'serviceReviewDescription',
  ),
  FavoriteServiceCategory(
    title: 'serviceArchitectureTitle',
    description: 'serviceArchitectureDescription',
  ),
  FavoriteServiceCategory(
    title: 'serviceFirebaseTitle',
    description: 'serviceFirebaseDescription',
  ),
  FavoriteServiceCategory(
    title: 'serviceAlgorithmsTitle',
    description: 'serviceAlgorithmsDescription',
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
