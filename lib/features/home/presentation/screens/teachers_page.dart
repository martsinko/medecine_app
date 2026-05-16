import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medicity_app/core/constants/app_index.dart';
import 'package:medicity_app/core/localization/app_localizations.dart';
import 'package:medicity_app/features/home/presentation/models/doctor_profile.dart';
import 'package:medicity_app/features/home/presentation/providers/teacher_filters_provider.dart';
import 'package:medicity_app/features/profile/presentation/providers/profile_provider.dart';

import '../providers/teacher_provider.dart';
import '../widgets/teachers/teacher_components.dart';

class TeachersPage extends ConsumerWidget {
  const TeachersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teachersAsync = ref.watch(teachersProvider);
    final filters = ref.watch(teacherListFiltersProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
          child: teachersAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) =>
                Center(child: Text(context.tr('failedLoadTeachers'))),
            data: (teachers) {
              final visibleTeachers = applyTeacherListFilters(
                teachers,
                filters,
              );

              return ListView.separated(
                padding: const EdgeInsets.only(bottom: 120),
                itemCount: visibleTeachers.isEmpty
                    ? 3
                    : visibleTeachers.length + 2,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return TeachersTopBar(
                      title: context.tr(teacherListTitle(filters)),
                    );
                  }

                  if (index == 1) {
                    return _TeacherFilterRow(filters: filters);
                  }

                  if (visibleTeachers.isEmpty) {
                    return const _EmptyTeachersMessage();
                  }

                  final teacher = visibleTeachers[index - 2];
                  return TeacherCompactCard(
                    doctor: teacher,
                    onInfoTap: () => context.goNamed(
                      AppRouteNames.teacherInfoPage,
                      pathParameters: {'teacherId': teacher.id},
                    ),
                    onCalendarTap: () => context.goNamed(
                      AppRouteNames.scheduleTeacherPage,
                      pathParameters: {'teacherId': teacher.id},
                    ),
                    onDetailsTap: () => context.goNamed(
                      AppRouteNames.teacherInfoPage,
                      pathParameters: {'teacherId': teacher.id},
                    ),
                    onFavoriteTap: () => _toggleFavorite(context, ref, teacher),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _toggleFavorite(
    BuildContext context,
    WidgetRef ref,
    DoctorProfile teacher,
  ) async {
    if (ref.read(currentUserIdProvider) == null) {
      context.goNamed(AppRouteNames.loginPage);
      return;
    }

    await ref
        .read(profileActionProvider.notifier)
        .toggleFavoriteTeacher(teacher.id, !teacher.isFavorite);
  }
}

class _TeacherFilterRow extends ConsumerWidget {
  final TeacherListFilters filters;

  const _TeacherFilterRow({required this.filters});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TeachersFilterRow(
      highlight: filters.sort == TeacherSortFilter.rating
          ? TeachersFilterHighlight.rating
          : TeachersFilterHighlight.none,
      azSelected: filters.sort == TeacherSortFilter.alphabetical,
      favoriteSelected: filters.favoriteOnly,
      selectedGender: filters.gender,
      showGenderFilters: true,
      onAZTap: () => _setSort(ref, TeacherSortFilter.alphabetical),
      onRatingTap: () => _setSort(ref, TeacherSortFilter.rating),
      onFavoriteTap: () {
        ref.read(teacherListFiltersProvider.notifier).state = filters.copyWith(
          favoriteOnly: !filters.favoriteOnly,
        );
      },
      onMaleTap: () => _toggleGender(ref, DoctorGender.male),
      onFemaleTap: () => _toggleGender(ref, DoctorGender.female),
    );
  }

  void _setSort(WidgetRef ref, TeacherSortFilter nextSort) {
    ref.read(teacherListFiltersProvider.notifier).state = filters.copyWith(
      sort: filters.sort == nextSort ? TeacherSortFilter.none : nextSort,
    );
  }

  void _toggleGender(WidgetRef ref, DoctorGender gender) {
    ref
        .read(teacherListFiltersProvider.notifier)
        .state = filters.gender == gender
        ? filters.copyWith(clearGender: true)
        : filters.copyWith(gender: gender);
  }
}

class _EmptyTeachersMessage extends StatelessWidget {
  const _EmptyTeachersMessage();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Text(
        context.tr('noTeachersMatchFilters'),
        textAlign: TextAlign.center,
        style: AppStyles.leagueSpartan16.copyWith(
          color: const Color(0xFF5E5E5E),
        ),
      ),
    );
  }
}
