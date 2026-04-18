enum DoctorGender { female, male }

class TeacherSchedule {
  final List<String> availableDates;
  final List<String> timeSlots;
  final int appointmentDuration;
  final bool bookingEnabled;

  const TeacherSchedule({
    required this.availableDates,
    required this.timeSlots,
    required this.appointmentDuration,
    required this.bookingEnabled,
  });

  static const TeacherSchedule empty = TeacherSchedule(
    availableDates: [],
    timeSlots: [],
    appointmentDuration: 30,
    bookingEnabled: false,
  );

  factory TeacherSchedule.fromMap(Map<String, dynamic> map) {
    return TeacherSchedule(
      availableDates: List<String>.from(map['availableDates'] ?? const []),
      timeSlots: List<String>.from(map['timeSlots'] ?? const []),
      appointmentDuration: (map['appointmentDuration'] as num?)?.toInt() ?? 30,
      bookingEnabled: map['bookingEnabled'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'availableDates': availableDates,
      'timeSlots': timeSlots,
      'appointmentDuration': appointmentDuration,
      'bookingEnabled': bookingEnabled,
    };
  }
}

class DoctorProfile {
  final String id;
  final String name;
  final String specialty;
  final String email;
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
  final bool available;
  final DoctorGender gender;
  final TeacherSchedule schedule;

  const DoctorProfile({
    required this.id,
    required this.name,
    required this.specialty,
    this.email = '',
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
    this.available = true,
    required this.gender,
    this.schedule = TeacherSchedule.empty,
  });

  DoctorProfile copyWith({
    String? id,
    String? name,
    String? specialty,
    String? email,
    double? rating,
    int? reviews,
    int? experienceYears,
    String? availability,
    String? imagePath,
    String? focus,
    String? profile,
    String? careerPath,
    String? highlights,
    bool? isFavorite,
    bool? available,
    DoctorGender? gender,
    TeacherSchedule? schedule,
  }) {
    return DoctorProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      email: email ?? this.email,
      rating: rating ?? this.rating,
      reviews: reviews ?? this.reviews,
      experienceYears: experienceYears ?? this.experienceYears,
      availability: availability ?? this.availability,
      imagePath: imagePath ?? this.imagePath,
      focus: focus ?? this.focus,
      profile: profile ?? this.profile,
      careerPath: careerPath ?? this.careerPath,
      highlights: highlights ?? this.highlights,
      isFavorite: isFavorite ?? this.isFavorite,
      available: available ?? this.available,
      gender: gender ?? this.gender,
      schedule: schedule ?? this.schedule,
    );
  }

  factory DoctorProfile.fromFirestore(
    String id,
    Map<String, dynamic> map, {
    bool isFavorite = false,
  }) {
    return DoctorProfile(
      id: id,
      name: map['name'] as String? ?? '',
      specialty: map['position'] as String? ?? '',
      email: map['email'] as String? ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 0,
      reviews: (map['reviews'] as num?)?.toInt() ?? 0,
      experienceYears: (map['experienceYears'] as num?)?.toInt() ?? 0,
      availability: map['workingHours'] as String? ?? '',
      imagePath: map['photoUrl'] as String? ?? '',
      focus: map['focus'] as String? ?? '',
      profile: map['profile'] as String? ?? '',
      careerPath: map['careerPath'] as String? ?? '',
      highlights: map['highlights'] as String? ?? '',
      isFavorite: isFavorite,
      available: map['available'] as bool? ?? true,
      gender: _inferGender(map['name'] as String? ?? ''),
      schedule: TeacherSchedule.fromMap(
        Map<String, dynamic>.from(map['schedule'] ?? const {}),
      ),
    );
  }
}

class FavoriteServiceCategory {
  final String title;
  final String description;

  const FavoriteServiceCategory({
    required this.title,
    required this.description,
  });
}

DoctorGender _inferGender(String fullName) {
  final normalized = fullName.toLowerCase();
  if (normalized.endsWith('а') || normalized.endsWith('я')) {
    return DoctorGender.female;
  }
  return DoctorGender.male;
}
