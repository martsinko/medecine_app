import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medicity_app/core/constants/app_index.dart';
import 'package:medicity_app/features/home/presentation/providers/teacher_provider.dart';
import 'package:medicity_app/shared/widgets/adaptive_avatar.dart';

import '../data/schedule_mock.dart';
import '../models/appointment_models.dart';
import '../providers/appointment_provider.dart';
import '../widgets/appointment_components.dart';

class ScheduleDoctorPage extends ConsumerWidget {
  final String doctorId;

  const ScheduleDoctorPage({super.key, required this.doctorId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(scheduleDraftProvider(doctorId));

    return ref
        .watch(teacherByIdProvider(doctorId))
        .when(
          data: (teacher) {
            if (teacher == null) {
              return const Scaffold(body: SafeArea(child: SizedBox.shrink()));
            }

            final dayOptions = buildScheduleDayOptions(
              teacher.schedule.availableDates,
            );
            final availableDays = availableCalendarDayNumbers(
              teacher.schedule.availableDates,
            );
            final calendarDays = buildMonthCalendarGrid(
              teacher.schedule.availableDates,
            );

            if (dayOptions.isNotEmpty &&
                !dayOptions.any(
                  (option) => option.dayNumber == draft.selectedCalendarDay,
                )) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ref
                    .read(scheduleDraftProvider(doctorId).notifier)
                    .selectWeekDay(dayOptions.first);
              });
            }

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
                          pathParameters: {'doctorId': teacher.id},
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
                                  backgroundColor: Colors.transparent,
                                  child: AdaptiveAvatar(
                                    imageSource: teacher.imagePath,
                                    radius: 56,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: InfoPill(
                                          icon: Icons.workspace_premium_rounded,
                                          label:
                                              '${teacher.experienceYears} years\nexperience',
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: AppColors.welcomeBlue,
                                          borderRadius: BorderRadius.circular(
                                            22,
                                          ),
                                        ),
                                        child: Text(
                                          teacher.focus,
                                          style: AppStyles.leagueSpartan12W300
                                              .copyWith(
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
                                    teacher.name,
                                    textAlign: TextAlign.center,
                                    style: AppStyles.leagueSpartan16.copyWith(
                                      color: AppColors.welcomeBlue,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    teacher.specialty,
                                    style: AppStyles.leagueSpartan12W300
                                        .copyWith(fontSize: 14),
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
                                  label: teacher.rating.toStringAsFixed(1),
                                ),
                                InfoPill(
                                  icon: Icons.chat_bubble_outline_rounded,
                                  label: '${teacher.reviews}',
                                ),
                                InfoPill(
                                  icon: Icons.watch_later_outlined,
                                  label: teacher.availability,
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
                        teacher.profile,
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
                                  scheduleMonthLabel(
                                    teacher.schedule.availableDates,
                                  ).toUpperCase(),
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
                                itemCount: calendarDays.length,
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
                                  final day = calendarDays[index];
                                  final selected =
                                      day == draft.selectedCalendarDay;
                                  final enabled =
                                      day != null &&
                                      availableDays.contains(day);

                                  return InkWell(
                                    borderRadius: BorderRadius.circular(999),
                                    onTap: !enabled
                                        ? null
                                        : () {
                                            final matchedOption = dayOptions
                                                .where(
                                                  (option) =>
                                                      option.dayNumber == day,
                                                )
                                                .first;
                                            ref
                                                .read(
                                                  scheduleDraftProvider(
                                                    teacher.id,
                                                  ).notifier,
                                                )
                                                .selectWeekDay(matchedOption);
                                            context.goNamed(
                                              AppRouteNames.scheduleFormPage,
                                              pathParameters: {
                                                'doctorId': teacher.id,
                                              },
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
                                        style: AppStyles.leagueSpartan12W300
                                            .copyWith(
                                              color: selected
                                                  ? Colors.white
                                                  : day == null
                                                  ? Colors.transparent
                                                  : enabled
                                                  ? const Color(0xFF7D8FE0)
                                                  : const Color(0xFFD0D8FF),
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
