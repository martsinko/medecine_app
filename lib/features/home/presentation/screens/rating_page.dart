import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medicity_app/core/constants/app_index.dart';

import '../data/doctors_mock.dart';
import '../models/doctor_profile.dart';
import '../widgets/doctors/doctor_components.dart';

class RatingPage extends StatelessWidget {
  const RatingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
          child: ListView.separated(
            padding: const EdgeInsets.only(bottom: 120),
            itemCount: doctorsMock.length + 2,
            separatorBuilder: (_, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              if (index == 0) {
                return const DoctorsTopBar(title: 'Rating');
              }

              if (index == 1) {
                return DoctorsFilterRow(
                  highlight: DoctorsFilterHighlight.rating,
                  onRatingTap: () {},
                  onFavoriteTap: () =>
                      context.goNamed(AppRouteNames.wishlistPage),
                );
              }

              final doctor = doctorsMock[index - 2];
              return _RatedDoctorCard(doctor: doctor);
            },
          ),
        ),
      ),
    );
  }
}

class _RatedDoctorCard extends StatelessWidget {
  final DoctorProfile doctor;

  const _RatedDoctorCard({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.signUpButtonBlue,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            children: [
              MetricBadge(
                icon: Icons.workspace_premium_outlined,
                label: 'Professional Doctor',
                foregroundColor: AppColors.welcomeBlue,
              ),
              const Spacer(),
              MetricBadge(
                icon: Icons.star_rounded,
                label: _formatRating(doctor.rating),
                foregroundColor: AppColors.welcomeBlue,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              CircleAvatar(
                radius: 34,
                backgroundImage: AssetImage(doctor.imagePath),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor.name,
                        style: AppStyles.leagueSpartan16.copyWith(
                          color: AppColors.welcomeBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        doctor.specialty,
                        style: AppStyles.leagueSpartan12W300.copyWith(
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              PrimaryPillButton(
                label: 'Info',
                onTap: () => context.goNamed(
                  AppRouteNames.doctorInfoPage,
                  pathParameters: {'doctorId': doctor.id},
                ),
              ),
              const Spacer(),
              RoundActionButton(
                icon: Icons.calendar_month_rounded,
                onTap: () => context.goNamed(
                  AppRouteNames.scheduleDoctorPage,
                  pathParameters: {'doctorId': doctor.id},
                ),
              ),
              const SizedBox(width: 4),
              const RoundActionButton(icon: Icons.info_outline_rounded),
              const SizedBox(width: 4),
              const RoundActionButton(icon: Icons.question_mark_rounded),
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

String _formatRating(double rating) {
  return rating.truncateToDouble() == rating
      ? rating.toInt().toString()
      : rating.toStringAsFixed(1);
}
