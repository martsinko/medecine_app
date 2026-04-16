import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medicity_app/core/constants/app_index.dart';
import 'package:medicity_app/features/home/presentation/data/doctors_mock.dart';

import '../models/appointment_models.dart';
import '../providers/appointment_provider.dart';
import '../widgets/appointment_components.dart';

class AppointmentsPage extends ConsumerStatefulWidget {
  final AppointmentStatus initialStatus;

  const AppointmentsPage({
    super.key,
    this.initialStatus = AppointmentStatus.complete,
  });

  @override
  ConsumerState<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends ConsumerState<AppointmentsPage> {
  late AppointmentStatus _selectedStatus;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.initialStatus;
  }

  @override
  void didUpdateWidget(covariant AppointmentsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialStatus != widget.initialStatus) {
      _selectedStatus = widget.initialStatus;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appointments = ref.watch(appointmentsProvider);
    final filteredAppointments = appointments
        .where((appointment) => appointment.status == _selectedStatus)
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
          child: ListView(
            padding: const EdgeInsets.only(bottom: 120),
            children: [
              const AppointmentTopBar(title: 'All Appointment'),
              const SizedBox(height: 18),
              AppointmentStatusTabs(
                selectedStatus: _selectedStatus,
                onSelected: (status) {
                  setState(() {
                    _selectedStatus = status;
                  });
                  context.goNamed(
                    AppRouteNames.appointmentsPage,
                    queryParameters: {'tab': _statusToQuery(status)},
                  );
                },
              ),
              const SizedBox(height: 22),
              for (final appointment in filteredAppointments) ...[
                _AppointmentCard(
                  appointment: appointment,
                  onMarkComplete: () {
                    ref
                        .read(appointmentsProvider.notifier)
                        .markAsComplete(appointment.id);
                    context.goNamed(
                      AppRouteNames.appointmentsPage,
                      queryParameters: {'tab': 'complete'},
                    );
                  },
                ),
                const SizedBox(height: 14),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _AppointmentCard extends ConsumerWidget {
  final AppointmentEntry appointment;
  final VoidCallback onMarkComplete;

  const _AppointmentCard({
    required this.appointment,
    required this.onMarkComplete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doctor = getDoctorById(appointment.doctorId);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.signUpButtonBlue,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          AppointmentDoctorHeader(
            doctor: doctor,
            trailing: appointment.status == AppointmentStatus.complete
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InfoPill(
                        icon: Icons.star_rounded,
                        label: '${appointment.reviewStars}',
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          appointment.isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: AppColors.welcomeBlue,
                          size: 15,
                        ),
                      ),
                    ],
                  )
                : null,
          ),
          const SizedBox(height: 10),
          if (appointment.status == AppointmentStatus.upcoming) ...[
            Row(
              children: [
                InfoPill(
                  icon: Icons.calendar_month_rounded,
                  label: appointment.dateLabel,
                ),
                const SizedBox(width: 8),
                InfoPill(
                  icon: Icons.watch_later_outlined,
                  label: appointment.timeLabel,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: AppointmentActionButton(
                    label: 'Details',
                    onTap: () => context.goNamed(
                      AppRouteNames.appointmentDetailsPage,
                      pathParameters: {'appointmentId': appointment.id},
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                CircleIconAction(
                  icon: Icons.check_rounded,
                  onTap: onMarkComplete,
                ),
                const SizedBox(width: 8),
                CircleIconAction(
                  icon: Icons.close_rounded,
                  onTap: () => context.goNamed(
                    AppRouteNames.cancelAppointmentPage,
                    pathParameters: {'appointmentId': appointment.id},
                  ),
                ),
              ],
            ),
          ] else if (appointment.status == AppointmentStatus.complete) ...[
            Row(
              children: [
                Expanded(
                  child: AppointmentActionButton(
                    label: 'Re-Book',
                    filled: false,
                    onTap: () => context.goNamed(
                      AppRouteNames.scheduleDoctorPage,
                      pathParameters: {'doctorId': doctor.id},
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AppointmentActionButton(
                    label: 'Add Review',
                    onTap: () => context.goNamed(
                      AppRouteNames.reviewAppointmentPage,
                      pathParameters: {'appointmentId': appointment.id},
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            AppointmentActionButton(
              label: 'Add Review',
              onTap: () => context.goNamed(
                AppRouteNames.reviewAppointmentPage,
                pathParameters: {'appointmentId': appointment.id},
              ),
            ),
          ],
        ],
      ),
    );
  }
}

AppointmentStatus appointmentStatusFromQuery(String? query) {
  return switch (query) {
    'upcoming' => AppointmentStatus.upcoming,
    'cancelled' => AppointmentStatus.cancelled,
    _ => AppointmentStatus.complete,
  };
}

String _statusToQuery(AppointmentStatus status) {
  return switch (status) {
    AppointmentStatus.complete => 'complete',
    AppointmentStatus.upcoming => 'upcoming',
    AppointmentStatus.cancelled => 'cancelled',
  };
}
