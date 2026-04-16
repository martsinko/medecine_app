enum DoctorGender { female, male }

class DoctorProfile {
  final String id;
  final String name;
  final String specialty;
  final double rating;
  final int reviews;
  final int experienceYears;
  final String availability;
  final String imagePath;
  final String focus;
  final String profile;
  final String careerPath;
  final String highlights;
  final bool isFavorite;
  final DoctorGender gender;

  const DoctorProfile({
    required this.id,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.reviews,
    required this.experienceYears,
    required this.availability,
    required this.imagePath,
    required this.focus,
    required this.profile,
    required this.careerPath,
    required this.highlights,
    this.isFavorite = false,
    required this.gender,
  });
}

class FavoriteServiceCategory {
  final String title;
  final String description;

  const FavoriteServiceCategory({
    required this.title,
    required this.description,
  });
}
