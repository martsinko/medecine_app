import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medicity_app/core/constants/app_index.dart';
import 'package:medicity_app/features/home/presentation/providers/teacher_provider.dart';

import '../models/appointment_models.dart';
import '../providers/appointment_provider.dart';
import '../widgets/appointment_components.dart';

class ScheduleFormPage extends ConsumerStatefulWidget {
  final String doctorId;

  const ScheduleFormPage({super.key, required this.doctorId});

  @override
  ConsumerState<ScheduleFormPage> createState() => _ScheduleFormPageState();
}

class _ScheduleFormPageState extends ConsumerState<ScheduleFormPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _ageController;
  late final TextEditingController _problemController;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(scheduleDraftProvider(widget.doctorId));
    _nameController = TextEditingController(text: draft.patientName);
    _ageController = TextEditingController(text: draft.patientAge);
    _problemController = TextEditingController(text: draft.problemDescription);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _problemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(scheduleDraftProvider(widget.doctorId));
    final notifier = ref.read(scheduleDraftProvider(widget.doctorId).notifier);

    return ref
        .watch(teacherByIdProvider(widget.doctorId))
        .when(
          data: (teacher) {
            if (teacher == null) {
              return const Scaffold(body: SafeArea(child: SizedBox.shrink()));
            }

            final dayOptions = buildScheduleDayOptions(
              teacher.schedule.availableDates,
            );
            final timeOptions = buildScheduleTimes(teacher.schedule.timeSlots);
            _syncDraftWithTeacherSchedule(
              notifier: notifier,
              draft: draft,
              dayOptions: dayOptions,
              timeOptions: timeOptions,
            );

            return Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 120),
                    children: [
                      ScheduleFlowHeader(
                        title: teacher.name,
                        onTitleTap: () => context.goNamed(
                          AppRouteNames.scheduleDoctorPage,
                          pathParameters: {'doctorId': teacher.id},
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
                        decoration: BoxDecoration(
                          color: AppColors.signUpButtonBlue,
                          borderRadius: BorderRadius.circular(26),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  scheduleMonthLabel(
                                    teacher.schedule.availableDates,
                                  ),
                                  style: AppStyles.leagueSpartan16.copyWith(
                                    color: AppColors.welcomeBlue,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: AppColors.welcomeBlue,
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                Icon(
                                  Icons.chevron_left_rounded,
                                  color: AppColors.hintColor,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: SizedBox(
                                    height: 86,
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: dayOptions.length,
                                      separatorBuilder: (_, index) =>
                                          const SizedBox(width: 8),
                                      itemBuilder: (context, index) {
                                        final option = dayOptions[index];
                                        final selected =
                                            option.fullLabel ==
                                            draft.selectedDay.fullLabel;
                                        return InkWell(
                                          borderRadius: BorderRadius.circular(
                                            22,
                                          ),
                                          onTap: () =>
                                              notifier.selectWeekDay(option),
                                          child: Container(
                                            width: 56,
                                            decoration: BoxDecoration(
                                              color: selected
                                                  ? AppColors.welcomeBlue
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(22),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '${option.dayNumber}',
                                                  style: AppStyles
                                                      .leagueSpartan24
                                                      .copyWith(
                                                        color: selected
                                                            ? Colors.white
                                                            : const Color(
                                                                0xFF8AA0F8,
                                                              ),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                ),
                                                Text(
                                                  option.weekday,
                                                  style: AppStyles
                                                      .leagueSpartan12W300
                                                      .copyWith(
                                                        color: selected
                                                            ? Colors.white
                                                            : const Color(
                                                                0xFF8AA0F8,
                                                              ),
                                                        fontSize: 13,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  color: AppColors.hintColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Available Time',
                        style: AppStyles.leagueSpartan16.copyWith(
                          color: AppColors.welcomeBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final time in timeOptions)
                            InkWell(
                              borderRadius: BorderRadius.circular(999),
                              onTap: () => notifier.selectTime(time),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: time == draft.selectedTime
                                      ? AppColors.welcomeBlue
                                      : AppColors.fillColor,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  time,
                                  style: AppStyles.leagueSpartan12W300.copyWith(
                                    color: time == draft.selectedTime
                                        ? Colors.white
                                        : AppColors.hintColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Divider(
                        color: AppColors.hintColor.withValues(alpha: 0.6),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Patient Details',
                        style: AppStyles.leagueSpartan16.copyWith(
                          color: AppColors.welcomeBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _OutlinedChip(
                            label: 'Yourself',
                            selected: draft.bookingForSelf,
                            onTap: () => notifier.setBookingForSelf(true),
                          ),
                          const SizedBox(width: 8),
                          _OutlinedChip(
                            label: 'Another Person',
                            selected: !draft.bookingForSelf,
                            onTap: () => notifier.setBookingForSelf(false),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const _FormLabel(label: 'Full Name'),
                      const SizedBox(height: 6),
                      _ScheduleField(
                        controller: _nameController,
                        onChanged: notifier.updatePatientName,
                      ),
                      const SizedBox(height: 10),
                      const _FormLabel(label: 'Age'),
                      const SizedBox(height: 6),
                      _ScheduleField(
                        controller: _ageController,
                        onChanged: notifier.updatePatientAge,
                      ),
                      const SizedBox(height: 10),
                      const _FormLabel(label: 'Gender'),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _OutlinedChip(
                            label: 'Male',
                            selected: draft.patientGender == PatientGender.male,
                            onTap: () => notifier.updatePatientGender(
                              PatientGender.male,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _OutlinedChip(
                            label: 'Female',
                            selected:
                                draft.patientGender == PatientGender.female,
                            onTap: () => notifier.updatePatientGender(
                              PatientGender.female,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _OutlinedChip(
                            label: 'Other',
                            selected:
                                draft.patientGender == PatientGender.other,
                            onTap: () => notifier.updatePatientGender(
                              PatientGender.other,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Divider(
                        color: AppColors.hintColor.withValues(alpha: 0.6),
                      ),
                      const SizedBox(height: 10),
                      const _FormLabel(label: 'Describe your problem'),
                      const SizedBox(height: 8),
                      Container(
                        height: 110,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.signUpButtonBlue),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: TextField(
                          controller: _problemController,
                          maxLines: null,
                          expands: true,
                          onChanged: notifier.updateProblemDescription,
                          decoration: InputDecoration(
                            hintText: 'Enter Your Problem Here...',
                            hintStyle: AppStyles.leagueSpartan16.copyWith(
                              color: AppColors.hintColor,
                            ),
                            contentPadding: const EdgeInsets.all(18),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      AppointmentActionButton(
                        label: 'Continue',
                        onTap: () async {
                          notifier.updatePatientName(
                            _nameController.text.trim(),
                          );
                          notifier.updatePatientAge(_ageController.text.trim());
                          notifier.updateProblemDescription(
                            _problemController.text.trim(),
                          );
                          final appointmentId = await ref
                              .read(appointmentActionProvider.notifier)
                              .createScheduledAppointment(
                                ref.read(
                                  scheduleDraftProvider(widget.doctorId),
                                ),
                              );
                          final actionState = ref.read(
                            appointmentActionProvider,
                          );
                          if (actionState.hasError && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(actionState.error.toString()),
                              ),
                            );
                            return;
                          }
                          if (context.mounted) {
                            context.goNamed(
                              AppRouteNames.appointmentDetailsPage,
                              pathParameters: {'appointmentId': appointmentId},
                            );
                          }
                        },
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

  void _syncDraftWithTeacherSchedule({
    required ScheduleDraftNotifier notifier,
    required ScheduleDraft draft,
    required List<ScheduleDayOption> dayOptions,
    required List<String> timeOptions,
  }) {
    if (dayOptions.isNotEmpty &&
        !dayOptions.any(
          (option) => option.fullLabel == draft.selectedDay.fullLabel,
        )) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifier.selectWeekDay(dayOptions.first);
      });
    }

    if (timeOptions.isNotEmpty && !timeOptions.contains(draft.selectedTime)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifier.selectTime(timeOptions.first);
      });
    }
  }
}

class _FormLabel extends StatelessWidget {
  final String label;

  const _FormLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppStyles.leagueSpartan12W300.copyWith(
        color: const Color(0xFF5D5D5D),
        fontSize: 14,
      ),
    );
  }
}

class _ScheduleField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _ScheduleField({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.fillColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
      style: AppStyles.leagueSpartan16.copyWith(
        color: AppColors.welcomeBlue,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _OutlinedChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _OutlinedChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.welcomeBlue : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.signUpButtonBlue),
        ),
        child: Text(
          label,
          style: AppStyles.leagueSpartan12W300.copyWith(
            color: selected ? Colors.white : AppColors.hintColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
