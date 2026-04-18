import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medicity_app/core/constants/app_index.dart';
import 'package:medicity_app/features/home/presentation/models/doctor_profile.dart';
import 'package:medicity_app/features/profile/presentation/providers/profile_provider.dart';
import 'package:medicity_app/shared/widgets/adaptive_avatar.dart';

import '../providers/teacher_provider.dart';
import '../widgets/doctors/doctor_components.dart';

class DoctorInfoPage extends ConsumerWidget {
  final String teacherId;

  const DoctorInfoPage({super.key, required this.teacherId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teacherAsync = ref.watch(teacherByIdProvider(teacherId));

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: teacherAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text('Error: $e')),
          data: (teacher) {
            if (teacher == null) {
              return const Center(child: Text('Teacher not found'));
            }
            return _buildContent(context, ref, teacher);
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, DoctorProfile teacher) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
      child: ListView(
        padding: const EdgeInsets.only(bottom: 120),
        children: [
          const DoctorsTopBar(title: 'Teacher Info'),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RoundActionButton(
                icon: Icons.star_rounded,
                onTap: () => context.goNamed(AppRouteNames.ratingPage),
              ),
              const SizedBox(width: 4),
              RoundActionButton(
                icon: Icons.favorite_rounded,
                selected: teacher.isFavorite,
                onTap: () => ref.read(profileActionProvider.notifier).toggleFavoriteTeacher(teacher.id, !teacher.isFavorite),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _DoctorInfoCard(doctor: teacher),
          const SizedBox(height: 26),
          const SectionTitle(title: 'Profile'),
          const SizedBox(height: 8),
          _BodyCopy(text: teacher.profile),
          const SizedBox(height: 20),
          const SectionTitle(title: 'Career Path'),
          const SizedBox(height: 8),
          _BodyCopy(text: teacher.careerPath),
          const SizedBox(height: 20),
          const SectionTitle(title: 'Highlights'),
          const SizedBox(height: 8),
          _BodyCopy(text: teacher.highlights),
        ],
      ),
    );
  }
}

class _DoctorInfoCard extends StatelessWidget {
  final DoctorProfile doctor;

  const _DoctorInfoCard({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.signUpButtonBlue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              AdaptiveAvatar(
                imageSource: doctor.imagePath,
                radius: 56,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.name,
                      style: AppStyles.leagueSpartan20.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      doctor.specialty,
                      style: AppStyles.leagueSpartan12W300,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                          child: Row(children: [
                            Icon(Icons.star_rounded, size: 14, color: AppColors.welcomeBlue),
                            const SizedBox(width: 4),
                            Text(doctor.rating.toStringAsFixed(1), style: AppStyles.leagueSpartan12W300),
                          ]),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                          child: Row(children: [
                            Icon(Icons.work_outline, size: 14, color: AppColors.welcomeBlue),
                            const SizedBox(width: 4),
                            Text('${doctor.experienceYears}y', style: AppStyles.leagueSpartan12W300),
                          ]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_today_outlined, color: AppColors.welcomeBlue, size: 18),
                      const SizedBox(width: 8),
                      Text(doctor.availability, style: AppStyles.leagueSpartan12W300.copyWith(color: AppColors.welcomeBlue, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                child: Row(
                  children: [
                    Icon(Icons.location_on_outlined, color: AppColors.welcomeBlue, size: 18),
                    const SizedBox(width: 4),
                    Text('地图', style: AppStyles.leagueSpartan14.copyWith(color: AppColors.welcomeBlue)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BodyCopy extends StatelessWidget {
  final String text;
  const _BodyCopy({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppStyles.leagueSpartan12W300.copyWith(height: 1.5));
  }
}