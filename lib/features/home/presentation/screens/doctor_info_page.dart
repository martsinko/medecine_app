import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medicity_app/core/constants/app_index.dart';
import 'package:medicity_app/features/home/presentation/models/doctor_profile.dart';
import 'package:medicity_app/shared/widgets/adaptive_avatar.dart';

import '../providers/teacher_provider.dart';
import '../widgets/doctors/doctor_components.dart';

class DoctorInfoPage extends ConsumerWidget {
  final String teacherId;

  const DoctorInfoPage({super.key, required this.teacherId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(teacherByIdProvider(teacherId))
        .when(
          data: (teacher) {
            if (teacher == null) {
              return const Scaffold(body: SafeArea(child: SizedBox.shrink()));
            }

            return Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 120),
                    children: [
                      const DoctorsTopBar(title: 'Teacher Info'),
                      const SizedBox(height: 16),
                      DoctorsFilterRow(
                        onRatingTap: () =>
                            context.goNamed(AppRouteNames.ratingPage),
                        onFavoriteTap: () =>
                            context.goNamed(AppRouteNames.wishlistPage),
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
                ),
              ),
            );
          },
          loading: () => const Scaffold(
            body: SafeArea(child: Center(child: CircularProgressIndicator())),
          ),
          error: (error, stackTrace) => const Scaffold(
            body: SafeArea(
              child: Center(child: Text('Failed to load teacher.')),
            ),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.signUpButtonBlue,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 54,
                backgroundColor: Colors.transparent,
                child: AdaptiveAvatar(
                  imageSource: doctor.imagePath,
                  radius: 54,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: MetricBadge(
                        icon: Icons.workspace_premium_rounded,
                        label: '${doctor.experienceYears} years\nexperience',
                        backgroundColor: AppColors.welcomeBlue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.welcomeBlue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        doctor.focus,
                        style: AppStyles.leagueSpartan12W300.copyWith(
                          color: Colors.white,
                          fontSize: 13,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                Text(
                  doctor.name,
                  textAlign: TextAlign.center,
                  style: AppStyles.leagueSpartan16.copyWith(
                    color: AppColors.welcomeBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  doctor.specialty,
                  textAlign: TextAlign.center,
                  style: AppStyles.leagueSpartan12W300.copyWith(fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              MetricBadge(
                icon: Icons.star_rounded,
                label: _formatRating(doctor.rating),
              ),
              MetricBadge(
                icon: Icons.rate_review_outlined,
                label: '${doctor.reviews} reviews',
              ),
              MetricBadge(
                icon: Icons.watch_later_outlined,
                label: doctor.availability,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: PrimaryPillButton(
                  label: 'Schedule',
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  onTap: () => context.goNamed(
                    AppRouteNames.scheduleDoctorPage,
                    pathParameters: {'doctorId': doctor.id},
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const RoundActionButton(icon: Icons.info_outline_rounded),
              const SizedBox(width: 4),
              const RoundActionButton(icon: Icons.question_mark_rounded),
              const SizedBox(width: 4),
              RoundActionButton(
                icon: Icons.star_rounded,
                onTap: () => context.goNamed(AppRouteNames.ratingPage),
              ),
              const SizedBox(width: 4),
              RoundActionButton(
                icon: Icons.favorite_rounded,
                selected: doctor.isFavorite,
                onTap: () => context.goNamed(AppRouteNames.wishlistPage),
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
    return Text(
      text,
      style: AppStyles.leagueSpartan12W300.copyWith(
        fontSize: 14,
        height: 1.2,
        color: const Color(0xFF393939),
      ),
    );
  }
}

String _formatRating(double rating) {
  return rating.truncateToDouble() == rating
      ? rating.toInt().toString()
      : rating.toStringAsFixed(1);
}
