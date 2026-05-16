import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medicity_app/core/constants/app_index.dart';
import 'package:medicity_app/core/localization/app_localizations.dart';
import 'package:medicity_app/features/home/presentation/providers/teacher_provider.dart';

import '../models/appointment_models.dart';
import '../providers/appointment_provider.dart';
import '../widgets/appointment_components.dart';

class CancelAppointmentPage extends ConsumerStatefulWidget {
  final String appointmentId;

  const CancelAppointmentPage({super.key, required this.appointmentId});

  @override
  ConsumerState<CancelAppointmentPage> createState() =>
      _CancelAppointmentPageState();
}

class _CancelAppointmentPageState extends ConsumerState<CancelAppointmentPage> {
  CancelReason _selectedReason = CancelReason.weatherConditions;
  late final TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ref
        .watch(appointmentsProvider)
        .when(
          data: (appointments) {
            final appointment = findAppointmentById(
              appointments,
              widget.appointmentId,
            );
            if (appointment == null) {
              return const Scaffold(body: SafeArea(child: SizedBox.shrink()));
            }
            return ref
                .watch(teacherByIdProvider(appointment.doctorId))
                .when(
                  data: (doctor) {
                    if (doctor == null) {
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
                                title: context.tr('cancelAppointment'),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                context.tr('cancelAppointmentDescription'),
                                style: AppStyles.leagueSpartan12W300.copyWith(
                                  color: const Color(0xFF5E5E5E),
                                  fontSize: 14,
                                  height: 1.18,
                                ),
                              ),
                              const SizedBox(height: 18),
                              AppointmentDoctorHeader(doctor: doctor),
                              const SizedBox(height: 22),
                              ReasonOptionTile(
                                title: context.tr('rescheduling'),
                                selected:
                                    _selectedReason ==
                                    CancelReason.rescheduling,
                                onTap: () => setState(
                                  () => _selectedReason =
                                      CancelReason.rescheduling,
                                ),
                              ),
                              ReasonOptionTile(
                                title: context.tr('weatherConditions'),
                                selected:
                                    _selectedReason ==
                                    CancelReason.weatherConditions,
                                onTap: () => setState(
                                  () => _selectedReason =
                                      CancelReason.weatherConditions,
                                ),
                              ),
                              ReasonOptionTile(
                                title: context.tr('unexpectedWork'),
                                selected:
                                    _selectedReason ==
                                    CancelReason.unexpectedWork,
                                onTap: () => setState(
                                  () => _selectedReason =
                                      CancelReason.unexpectedWork,
                                ),
                              ),
                              ReasonOptionTile(
                                title: context.tr('others'),
                                selected:
                                    _selectedReason == CancelReason.others,
                                onTap: () => setState(
                                  () => _selectedReason = CancelReason.others,
                                ),
                              ),
                              const SizedBox(height: 18),
                              Text(
                                context.tr('cancelAppointmentNote'),
                                style: AppStyles.leagueSpartan12W300.copyWith(
                                  color: AppColors.hintColor,
                                  fontSize: 14,
                                  height: 1.18,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                height: 150,
                                decoration: BoxDecoration(
                                  color: AppColors.fillColor,
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                child: TextField(
                                  controller: _commentController,
                                  maxLines: null,
                                  expands: true,
                                  decoration: InputDecoration(
                                    hintText: context.tr('enterReason'),
                                    hintStyle: AppStyles.leagueSpartan16
                                        .copyWith(color: AppColors.hintColor),
                                    contentPadding: const EdgeInsets.all(18),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 34),
                              AppointmentActionButton(
                                label: context.tr('cancelAppointment'),
                                onTap: () async {
                                  await ref
                                      .read(appointmentActionProvider.notifier)
                                      .cancelAppointment(
                                        appointment.id,
                                        reason: _selectedReason,
                                        comment: _commentController.text.trim(),
                                      );
                                  if (context.mounted) {
                                    context.goNamed(
                                      AppRouteNames.appointmentsPage,
                                      queryParameters: {'tab': 'cancelled'},
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
