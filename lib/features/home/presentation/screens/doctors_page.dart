import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medicity_app/core/constants/app_index.dart';

import '../data/doctors_mock.dart';
import '../widgets/doctors/doctor_components.dart';

class DoctorsPage extends StatelessWidget {
  const DoctorsPage({super.key});

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
            separatorBuilder: (_, index) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              if (index == 0) {
                return const DoctorsTopBar(title: 'Doctors');
              }

              if (index == 1) {
                return DoctorsFilterRow(
                  onRatingTap: () => context.goNamed(AppRouteNames.ratingPage),
                  onFavoriteTap: () =>
                      context.goNamed(AppRouteNames.wishlistPage),
                );
              }

              final doctor = doctorsMock[index - 2];
              return DoctorCompactCard(
                doctor: doctor,
                onInfoTap: () => context.goNamed(
                  AppRouteNames.doctorInfoPage,
                  pathParameters: {'doctorId': doctor.id},
                ),
                onCalendarTap: () => context.goNamed(
                  AppRouteNames.scheduleDoctorPage,
                  pathParameters: {'doctorId': doctor.id},
                ),
                onDetailsTap: () => context.goNamed(
                  AppRouteNames.doctorInfoPage,
                  pathParameters: {'doctorId': doctor.id},
                ),
                onFavoriteTap: () =>
                    context.goNamed(AppRouteNames.wishlistPage),
              );
            },
          ),
        ),
      ),
    );
  }
}
