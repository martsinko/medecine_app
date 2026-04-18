import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medicity_app/core/constants/app_index.dart';
import 'package:medicity_app/features/home/presentation/models/doctor_profile.dart';
import 'package:medicity_app/features/profile/presentation/providers/profile_provider.dart';

import '../providers/teacher_provider.dart';
import '../widgets/doctors/doctor_components.dart';

enum SortFilter { alphabetical, rating, favorite, none }

final sortFilterProvider = StateProvider<SortFilter>(
  (ref) => SortFilter.alphabetical,
);
final genderFilterProvider = StateProvider<DoctorGender?>((ref) => null);

class DoctorsPage extends ConsumerWidget {
  const DoctorsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teachersAsync = ref.watch(teachersProvider);
    final sortFilter = ref.watch(sortFilterProvider);
    final genderFilter = ref.watch(genderFilterProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
          child: teachersAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, __) => Center(child: Text('Failed to load teachers.')),
            data: (teachers) {
              var list = teachers.toList();

              if (genderFilter != null) {
                list = list.where((t) => t.gender == genderFilter).toList();
              }

              switch (sortFilter) {
                case SortFilter.alphabetical:
                  list.sort((a, b) => a.name.compareTo(b.name));
                case SortFilter.rating:
                  list.sort((a, b) => b.rating.compareTo(a.rating));
                case SortFilter.favorite:
                  list.sort((a, b) {
                    if (a.isFavorite != b.isFavorite) {
                      return a.isFavorite ? -1 : 1;
                    }
                    return a.name.compareTo(b.name);
                  });
                case SortFilter.none:
                  break;
              }

              return ListView.separated(
                padding: const EdgeInsets.only(bottom: 120),
                itemCount: list.length + 2,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (ctx, index) {
                  if (index == 0) {
                    return DoctorsTopBar(
                      title: _getTitle(sortFilter, genderFilter),
                    );
                  }
                  if (index == 1) {
                    return _buildFilterRow(ref, sortFilter, genderFilter);
                  }
                  final teacher = list[index - 2];
                  return DoctorCompactCard(
                    doctor: teacher,
                    onInfoTap: () => context.goNamed(
                      AppRouteNames.doctorInfoPage,
                      pathParameters: {'doctorId': teacher.id},
                    ),
                    onCalendarTap: () => context.goNamed(
                      AppRouteNames.scheduleDoctorPage,
                      pathParameters: {'doctorId': teacher.id},
                    ),
                    onDetailsTap: () => context.goNamed(
                      AppRouteNames.doctorInfoPage,
                      pathParameters: {'doctorId': teacher.id},
                    ),
                    onFavoriteTap: () => ref
                        .read(profileActionProvider.notifier)
                        .toggleFavoriteTeacher(teacher.id, !teacher.isFavorite),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFilterRow(WidgetRef ref, SortFilter sort, DoctorGender? gender) {
    final hl = sort == SortFilter.rating
        ? DoctorsFilterHighlight.rating
        : sort == SortFilter.favorite
        ? DoctorsFilterHighlight.favorite
        : DoctorsFilterHighlight.none;

    return DoctorsFilterRow(
      highlight: hl,
      favoriteSelected: sort == SortFilter.favorite,
      selectedGender: gender,
      showGenderFilters: true,
      onAZTap: () {
        final curr = ref.read(sortFilterProvider);
        ref
            .read(sortFilterProvider.notifier)
            .state = curr == SortFilter.alphabetical
            ? SortFilter.none
            : SortFilter.alphabetical;
      },
      onRatingTap: () {
        ref.read(sortFilterProvider.notifier).state = sort == SortFilter.rating
            ? SortFilter.none
            : SortFilter.rating;
      },
      onFavoriteTap: () {
        ref.read(sortFilterProvider.notifier).state =
            sort == SortFilter.favorite ? SortFilter.none : SortFilter.favorite;
      },
      onMaleTap: () {
        final curr = ref.read(genderFilterProvider);
        ref.read(genderFilterProvider.notifier).state =
            curr == DoctorGender.male ? null : DoctorGender.male;
      },
      onFemaleTap: () {
        final curr = ref.read(genderFilterProvider);
        ref.read(genderFilterProvider.notifier).state =
            curr == DoctorGender.female ? null : DoctorGender.female;
      },
    );
  }

  String _getTitle(SortFilter sort, DoctorGender? gender) {
    if (gender != null) {
      return '${gender.name[0].toUpperCase()}${gender.name.substring(1)}';
    }
    switch (sort) {
      case SortFilter.alphabetical:
        return 'Teachers';
      case SortFilter.rating:
        return 'Rating';
      case SortFilter.favorite:
        return 'Favorite';
      case SortFilter.none:
        return 'Teachers';
    }
  }
}
