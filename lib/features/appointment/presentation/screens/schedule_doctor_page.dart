import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medicity_app/core/constants/app_index.dart';
import 'package:medicity_app/features/home/presentation/data/doctors_mock.dart';

import '../data/schedule_mock.dart';
import '../providers/appointment_provider.dart';
import '../widgets/appointment_components.dart';

class ScheduleDoctorPage extends ConsumerWidget {
  final String doctorId;

  const ScheduleDoctorPage({super.key, required this.doctorId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doctor = getDoctorById(doctorId);
    final draft = ref.watch(scheduleDraftProvider(doctorId));

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
          child: ListView(
            padding: const EdgeInsets.only(bottom: 120),
            children: [
              ScheduleFlowHeader(
                title: 'Schedule',
                onTitleTap: () => context.goNamed(
                  AppRouteNames.scheduleFormPage,
                  pathParameters: {'doctorId': doctor.id},
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.signUpButtonBlue,
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 56,
                          backgroundImage: AssetImage(doctor.imagePath),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Align(
                                alignment: Alignment.centerRight,
                                child: InfoPill(
                                  icon: Icons.workspace_premium_rounded,
                                  label:
                                      '${doctor.experienceYears + 9} years\nexperience',
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.welcomeBlue,
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                child: Text(
                                  doctor.focus,
                                  style: AppStyles.leagueSpartan12W300.copyWith(
                                    color: Colors.white,
                                    fontSize: 13,
                                    height: 1.15,
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
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
                          const SizedBox(height: 2),
                          Text(
                            doctor.specialty,
                            style: AppStyles.leagueSpartan12W300.copyWith(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        InfoPill(
                          icon: Icons.star_rounded,
                          label: doctor.rating.toStringAsFixed(1),
                        ),
                        InfoPill(
                          icon: Icons.chat_bubble_outline_rounded,
                          label: '${doctor.reviews}',
                        ),
                        InfoPill(
                          icon: Icons.watch_later_outlined,
                          label: 'Mon - Sat / 9 AM - 4 PM',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Profile',
                style: AppStyles.leagueSpartan16.copyWith(
                  color: AppColors.welcomeBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                doctor.profile,
                style: AppStyles.leagueSpartan12W300.copyWith(
                  fontSize: 14,
                  height: 1.18,
                  color: const Color(0xFF565656),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
                decoration: BoxDecoration(
                  color: AppColors.signUpButtonBlue,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chevron_left_rounded,
                          color: AppColors.welcomeBlue,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'MONTH',
                          style: AppStyles.leagueSpartan16.copyWith(
                            color: AppColors.welcomeBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: AppColors.welcomeBlue,
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (final weekday in monthWeekdays)
                          _WeekdayChip(label: weekday),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: GridView.builder(
                        itemCount: monthCalendarDays.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 7,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 8,
                              childAspectRatio: 1,
                            ),
                        itemBuilder: (context, index) {
                          final day = monthCalendarDays[index];
                          final selected = day == draft.selectedCalendarDay;
                          return InkWell(
                            borderRadius: BorderRadius.circular(999),
                            onTap: day == null
                                ? null
                                : () {
                                    ref
                                        .read(
                                          scheduleDraftProvider(
                                            doctor.id,
                                          ).notifier,
                                        )
                                        .selectCalendarDay(day);
                                    context.goNamed(
                                      AppRouteNames.scheduleFormPage,
                                      pathParameters: {'doctorId': doctor.id},
                                    );
                                  },
                            child: Container(
                              decoration: BoxDecoration(
                                color: selected
                                    ? AppColors.welcomeBlue
                                    : Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${day ?? ''}',
                                style: AppStyles.leagueSpartan12W300.copyWith(
                                  color: selected
                                      ? Colors.white
                                      : day == null
                                      ? Colors.transparent
                                      : const Color(0xFF7D8FE0),
                                  fontSize: 15,
                                  fontWeight: selected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeekdayChip extends StatelessWidget {
  final String label;

  const _WeekdayChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.welcomeBlue,
        borderRadius: BorderRadius.circular(999),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: AppStyles.leagueSpartan12W600.copyWith(fontSize: 12),
      ),
    );
  }
}
