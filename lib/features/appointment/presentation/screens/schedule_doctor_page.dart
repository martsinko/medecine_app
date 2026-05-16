import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medicity_app/core/constants/app_index.dart';
import 'package:medicity_app/core/localization/app_localizations.dart';
import 'package:medicity_app/features/home/presentation/models/doctor_profile.dart';
import 'package:medicity_app/features/home/presentation/providers/teacher_provider.dart';
import 'package:medicity_app/features/profile/presentation/providers/profile_provider.dart';
import 'package:medicity_app/shared/widgets/adaptive_avatar.dart';

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
            final displayedMonth = displayedScheduleMonth(
              teacher.schedule.availableDates,
              draft.selectedMonthIndex,
            );
            final availableDays = availableCalendarDayNumbers(
              teacher.schedule.availableDates,
              month: displayedMonth,
            );
            final calendarDays = buildMonthCalendarGridFor(displayedMonth);

            if (dayOptions.isNotEmpty &&
                !dayOptions.any(
                  (option) => option.fullLabel == draft.selectedDay.fullLabel,
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
                        title: context.tr('schedule'),
                        onTitleTap: () => context.goNamed(
                          AppRouteNames.scheduleFormPage,
                          pathParameters: {'teacherId': teacher.id},
                        ),
                        onSupportTap: () =>
                            context.pushNamed(AppRouteNames.helpCenterPage),
                        onHelpTap: () =>
                            context.pushNamed(AppRouteNames.helpCenterPage),
                        favoriteSelected: teacher.isFavorite,
                        onFavoriteTap: () =>
                            _toggleFavorite(context, ref, teacher),
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
                                          label: context.tr('yearsExperience', {
                                            'years': teacher.experienceYears,
                                          }),
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
                                          context.tr(teacher.focus),
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
                                    context.tr(teacher.specialty),
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
                                _TappablePill(
                                  onTap: () =>
                                      context.goNamed(AppRouteNames.ratingPage),
                                  child: InfoPill(
                                    icon: Icons.star_rounded,
                                    label: teacher.rating.toStringAsFixed(1),
                                  ),
                                ),
                                _TappablePill(
                                  onTap: () =>
                                      context.goNamed(AppRouteNames.ratingPage),
                                  child: InfoPill(
                                    icon: Icons.rate_review_outlined,
                                    label: context.tr('reviewsCount', {
                                      'count': teacher.reviews,
                                    }),
                                  ),
                                ),
                                _TappablePill(
                                  onTap: () => context.goNamed(
                                    AppRouteNames.scheduleFormPage,
                                    pathParameters: {'teacherId': teacher.id},
                                  ),
                                  child: InfoPill(
                                    icon: Icons.watch_later_outlined,
                                    label: context.tr(teacher.availability),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        context.tr('profileSection'),
                        style: AppStyles.leagueSpartan16.copyWith(
                          color: AppColors.welcomeBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.tr(teacher.profile),
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
                                InkWell(
                                  borderRadius: BorderRadius.circular(999),
                                  onTap: () => ref
                                      .read(
                                        scheduleDraftProvider(
                                          doctorId,
                                        ).notifier,
                                      )
                                      .previousMonth(),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Icon(
                                      Icons.chevron_left_rounded,
                                      color: AppColors.welcomeBlue,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  scheduleMonthLabelFor(
                                    displayedMonth,
                                  ).toUpperCase(),
                                  style: AppStyles.leagueSpartan16.copyWith(
                                    color: AppColors.welcomeBlue,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                InkWell(
                                  borderRadius: BorderRadius.circular(999),
                                  onTap: () => ref
                                      .read(
                                        scheduleDraftProvider(
                                          doctorId,
                                        ).notifier,
                                      )
                                      .nextMonth(),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Icon(
                                      Icons.chevron_right_rounded,
                                      color: AppColors.welcomeBlue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                for (final weekday in localizedWeekdayCodes())
                                  _WeekdayChip(
                                    label: weekday,
                                    onTap: () => _selectFirstAvailableWeekday(
                                      ref,
                                      teacher.id,
                                      weekday,
                                      dayOptions,
                                      displayedMonth,
                                    ),
                                  ),
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
                                  final selected = isSelectedScheduleDay(
                                    selectedDay: draft.selectedDay,
                                    calendarDay: day,
                                    displayedMonth: displayedMonth,
                                  );
                                  final enabled =
                                      day != null &&
                                      availableDays.contains(day);

                                  return InkWell(
                                    borderRadius: BorderRadius.circular(999),
                                    onTap: !enabled
                                        ? null
                                        : () {
                                            final matchedOption = dayOptions
                                                .firstWhere(
                                                  (option) =>
                                                      option.dayNumber == day &&
                                                      option.month ==
                                                          displayedMonth
                                                              .month &&
                                                      option.year ==
                                                          displayedMonth.year,
                                                );
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
                                                'teacherId': teacher.id,
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
          error: (error, stackTrace) => Scaffold(
            body: SafeArea(
              child: Center(child: Text(context.tr('failedLoadTeacher'))),
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

  void _selectFirstAvailableWeekday(
    WidgetRef ref,
    String teacherId,
    String weekday,
    List<ScheduleDayOption> dayOptions,
    DateTime displayedMonth,
  ) {
    final monthOptions = dayOptions.where(
      (option) =>
          option.weekday == weekday &&
          option.month == displayedMonth.month &&
          option.year == displayedMonth.year,
    );
    if (monthOptions.isEmpty) {
      return;
    }
    ref
        .read(scheduleDraftProvider(teacherId).notifier)
        .selectWeekDay(monthOptions.first);
  }
}

class _TappablePill extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const _TappablePill({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: child,
    );
  }
}

class _WeekdayChip extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _WeekdayChip({required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
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
      ),
    );
  }
}
