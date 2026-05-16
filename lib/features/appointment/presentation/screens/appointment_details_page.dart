import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medicity_app/core/constants/app_index.dart';
import 'package:medicity_app/core/localization/app_localizations.dart';
import 'package:medicity_app/features/home/presentation/providers/teacher_provider.dart';

import '../models/appointment_models.dart';
import '../providers/appointment_provider.dart';
import '../widgets/appointment_components.dart';

class AppointmentDetailsPage extends ConsumerWidget {
  final String appointmentId;

  const AppointmentDetailsPage({super.key, required this.appointmentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(appointmentsProvider)
        .when(
          data: (appointments) {
            final appointment = findAppointmentById(
              appointments,
              appointmentId,
            );
            if (appointment == null) {
              return const Scaffold(body: SafeArea(child: SizedBox.shrink()));
            }

            return ref
                .watch(teacherByIdProvider(appointment.doctorId))
                .when(
                  data: (teacher) {
                    if (teacher == null) {
                      return const Scaffold(
                        body: SafeArea(child: SizedBox.shrink()),
                      );
                    }

                    return Scaffold(
                      backgroundColor: Colors.white,
                      body: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
                          child: ListView(
                            padding: const EdgeInsets.only(bottom: 120),
                            children: [
                              AppointmentTopBar(
                                title: context.tr('yourAppointment'),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: AppColors.signUpButtonBlue,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Column(
                                  children: [
                                    AppointmentDoctorHeader(doctor: teacher),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        InfoPill(
                                          icon: Icons.star_rounded,
                                          label: teacher.rating.toStringAsFixed(
                                            1,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        InfoPill(
                                          icon: Icons.rate_review_outlined,
                                          label: context.tr('reviewsCount', {
                                            'count': teacher.reviews,
                                          }),
                                        ),
                                        const Spacer(),
                                        CircleIconAction(
                                          icon: Icons.question_mark_rounded,
                                          onTap: () {},
                                        ),
                                        const SizedBox(width: 6),
                                        CircleIconAction(
                                          icon: teacher.isFavorite
                                              ? Icons.favorite_rounded
                                              : Icons.favorite_border_rounded,
                                          onTap: () {},
                                          selected: teacher.isFavorite,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                              Divider(
                                color: AppColors.hintColor.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                              const SizedBox(height: 18),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 18,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.welcomeBlue,
                                            borderRadius: BorderRadius.circular(
                                              999,
                                            ),
                                          ),
                                          child: Text(
                                            appointment.dateLabel.contains(',')
                                                ? appointment.dateLabel
                                                      .split(',')
                                                      .first
                                                : appointment.dateLabel,
                                            style: AppStyles.leagueSpartan16
                                                .copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          appointment.timeLabel,
                                          style: AppStyles.leagueSpartan12W300
                                              .copyWith(
                                                color: AppColors.welcomeBlue,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  CircleIconAction(
                                    icon: Icons.check_rounded,
                                    onTap: () => context.goNamed(
                                      AppRouteNames.appointmentsPage,
                                      queryParameters: {'tab': 'upcoming'},
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  CircleIconAction(
                                    icon: Icons.close_rounded,
                                    onTap: () => context.goNamed(
                                      AppRouteNames.cancelAppointmentPage,
                                      pathParameters: {
                                        'appointmentId': appointment.id,
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              Divider(
                                color: AppColors.hintColor.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                              const SizedBox(height: 18),
                              _InfoRow(
                                label: context.tr('bookingFor'),
                                value: appointment.bookingForSelf
                                    ? context.tr('yourself')
                                    : context.tr('anotherPerson'),
                              ),
                              _InfoRow(
                                label: context.tr('fullName'),
                                value: appointment.patientName,
                              ),
                              _InfoRow(
                                label: context.tr('age'),
                                value: appointment.patientAge,
                              ),
                              _InfoRow(
                                label: context.tr('gender'),
                                value: _genderLabel(
                                  context,
                                  appointment.patientGender,
                                ),
                              ),
                              const SizedBox(height: 18),
                              Divider(
                                color: AppColors.hintColor.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                              const SizedBox(height: 18),
                              Text(
                                context.tr('problem'),
                                style: AppStyles.leagueSpartan12W300.copyWith(
                                  color: const Color(0xFF5D5D5D),
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                appointment.problemDescription,
                                style: AppStyles.leagueSpartan12W300.copyWith(
                                  color: const Color(0xFF555555),
                                  fontSize: 14,
                                  height: 1.16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  loading: () => const Scaffold(
                    body: SafeArea(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                  error: (error, stackTrace) => Scaffold(
                    body: SafeArea(
                      child: Center(
                        child: Text(context.tr('failedLoadTeacher')),
                      ),
                    ),
                  ),
                );
          },
          loading: () => const Scaffold(
            body: SafeArea(child: Center(child: CircularProgressIndicator())),
          ),
          error: (error, stackTrace) => Scaffold(
            body: SafeArea(
              child: Center(child: Text(context.tr('failedLoadAppointment'))),
            ),
          ),
        );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppStyles.leagueSpartan12W300.copyWith(
                color: const Color(0xFF5D5D5D),
                fontSize: 14,
              ),
            ),
          ),
          Text(
            value,
            style: AppStyles.leagueSpartan12W300.copyWith(
              color: const Color(0xFF3E3E3E),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

String _genderLabel(BuildContext context, PatientGender gender) {
  return switch (gender) {
    PatientGender.male => context.tr('male'),
    PatientGender.female => context.tr('female'),
    PatientGender.other => context.tr('other'),
  };
}
