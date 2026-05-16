import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/doctor_profile.dart';

enum TeacherSortFilter { alphabetical, rating, none }

class TeacherListFilters {
  final TeacherSortFilter sort;
  final DoctorGender? gender;
  final bool favoriteOnly;

  const TeacherListFilters({
    this.sort = TeacherSortFilter.alphabetical,
    this.gender,
    this.favoriteOnly = false,
  });

  TeacherListFilters copyWith({
    TeacherSortFilter? sort,
    DoctorGender? gender,
    bool clearGender = false,
    bool? favoriteOnly,
  }) {
    return TeacherListFilters(
      sort: sort ?? this.sort,
      gender: clearGender ? null : (gender ?? this.gender),
      favoriteOnly: favoriteOnly ?? this.favoriteOnly,
    );
  }
}

final teacherListFiltersProvider =
    StateProvider.autoDispose<TeacherListFilters>(
      (ref) => const TeacherListFilters(),
    );

List<DoctorProfile> applyTeacherListFilters(
  List<DoctorProfile> teachers,
  TeacherListFilters filters,
) {
  var result = teachers.where((teacher) {
    final matchesFavorite = !filters.favoriteOnly || teacher.isFavorite;
    final matchesGender =
        filters.gender == null || teacher.gender == filters.gender;
    return matchesFavorite && matchesGender;
  }).toList();

  switch (filters.sort) {
    case TeacherSortFilter.alphabetical:
      result.sort((a, b) => a.name.compareTo(b.name));
    case TeacherSortFilter.rating:
      result.sort((a, b) {
        final ratingCompare = b.rating.compareTo(a.rating);
        if (ratingCompare != 0) {
          return ratingCompare;
        }
        return a.name.compareTo(b.name);
      });
    case TeacherSortFilter.none:
      break;
  }

  return result;
}

String teacherListTitle(TeacherListFilters filters) {
  final genderTitle = switch (filters.gender) {
    DoctorGender.female => 'female',
    DoctorGender.male => 'male',
    null => null,
  };

  if (filters.favoriteOnly && genderTitle != null) {
    return filters.gender == DoctorGender.female
        ? 'favoriteFemale'
        : 'favoriteMale';
  }

  if (filters.favoriteOnly) {
    return 'favorite';
  }

  if (genderTitle != null) {
    return genderTitle;
  }

  return switch (filters.sort) {
    TeacherSortFilter.rating => 'rating',
    TeacherSortFilter.alphabetical || TeacherSortFilter.none => 'teachers',
  };
}
