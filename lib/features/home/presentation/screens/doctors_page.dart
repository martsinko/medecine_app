import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medicity_app/core/constants/app_index.dart';
import 'package:medicity_app/features/profile/presentation/providers/profile_provider.dart';

import '../providers/teacher_provider.dart';
import '../widgets/doctors/doctor_components.dart';

class DoctorsPage extends ConsumerWidget {
  const DoctorsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(teachersProvider)
        .when(
          data: (teachers) => Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
                child: ListView.separated(
                  padding: const EdgeInsets.only(bottom: 120),
                  itemCount: teachers.length + 2,
                  separatorBuilder: (_, index) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return const DoctorsTopBar(title: 'Teachers');
                    }

                    if (index == 1) {
                      return DoctorsFilterRow(
                        onRatingTap: () =>
                            context.goNamed(AppRouteNames.ratingPage),
                        onFavoriteTap: () =>
                            context.goNamed(AppRouteNames.wishlistPage),
                      );
                    }

                    final teacher = teachers[index - 2];
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
                          .toggleFavoriteTeacher(
                            teacher.id,
                            !teacher.isFavorite,
                          ),
                    );
                  },
                ),
              ),
            ),
          ),
          loading: () => const Scaffold(
            body: SafeArea(child: Center(child: CircularProgressIndicator())),
          ),
          error: (error, stackTrace) => const Scaffold(
            body: SafeArea(
              child: Center(child: Text('Failed to load teachers.')),
            ),
          ),
        );
  }
}
