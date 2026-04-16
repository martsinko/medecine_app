import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medicity_app/core/constants/app_index.dart';
import 'package:medicity_app/features/home/presentation/data/doctors_mock.dart';

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
    final appointments = ref.watch(appointmentsProvider);
    final appointment = findAppointmentById(appointments, widget.appointmentId);
    if (appointment == null) {
      return const Scaffold(body: SafeArea(child: SizedBox.shrink()));
    }
    final doctor = getDoctorById(appointment.doctorId);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
          child: ListView(
            padding: const EdgeInsets.only(bottom: 120),
            children: [
              const AppointmentTopBar(title: 'Cancel Appointment'),
              const SizedBox(height: 16),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
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
                title: 'Rescheduling',
                selected: _selectedReason == CancelReason.rescheduling,
                onTap: () {
                  setState(() {
                    _selectedReason = CancelReason.rescheduling;
                  });
                },
              ),
              ReasonOptionTile(
                title: 'Weather Conditions',
                selected: _selectedReason == CancelReason.weatherConditions,
                onTap: () {
                  setState(() {
                    _selectedReason = CancelReason.weatherConditions;
                  });
                },
              ),
              ReasonOptionTile(
                title: 'Unexpected Work',
                selected: _selectedReason == CancelReason.unexpectedWork,
                onTap: () {
                  setState(() {
                    _selectedReason = CancelReason.unexpectedWork;
                  });
                },
              ),
              ReasonOptionTile(
                title: 'Others',
                selected: _selectedReason == CancelReason.others,
                onTap: () {
                  setState(() {
                    _selectedReason = CancelReason.others;
                  });
                },
              ),
              const SizedBox(height: 18),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
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
                    hintText: 'Enter Your Reason Here....',
                    hintStyle: AppStyles.leagueSpartan16.copyWith(
                      color: AppColors.hintColor,
                    ),
                    contentPadding: const EdgeInsets.all(18),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 34),
              AppointmentActionButton(
                label: 'Cancel Appointment',
                onTap: () {
                  ref
                      .read(appointmentsProvider.notifier)
                      .cancelAppointment(
                        appointment.id,
                        reason: _selectedReason,
                        comment: _commentController.text.trim(),
                      );
                  context.goNamed(
                    AppRouteNames.appointmentsPage,
                    queryParameters: {'tab': 'cancelled'},
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
