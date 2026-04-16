import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/appointments_mock.dart';
import '../data/schedule_mock.dart';
import '../models/appointment_models.dart';

final appointmentsProvider =
    StateNotifierProvider<AppointmentsNotifier, List<AppointmentEntry>>((ref) {
      return AppointmentsNotifier();
    });

final scheduleDraftProvider =
    StateNotifierProvider.family<ScheduleDraftNotifier, ScheduleDraft, String>((
      ref,
      doctorId,
    ) {
      return ScheduleDraftNotifier(
        ScheduleDraft(
          doctorId: doctorId,
          selectedMonthIndex: 0,
          selectedCalendarDay: 24,
          selectedDay: scheduleWeekOptions[2],
          selectedTime: '10:00 AM',
          bookingForSelf: false,
          patientName: 'Jane Doe',
          patientAge: '30',
          patientGender: PatientGender.female,
          problemDescription: '',
        ),
      );
    });

class AppointmentsNotifier extends StateNotifier<List<AppointmentEntry>> {
  AppointmentsNotifier() : super(appointmentsMock);

  void markAsComplete(String appointmentId) {
    state = [
      for (final appointment in state)
        if (appointment.id == appointmentId)
          appointment.copyWith(status: AppointmentStatus.complete)
        else
          appointment,
    ];
  }

  void cancelAppointment(
    String appointmentId, {
    required CancelReason reason,
    required String comment,
  }) {
    state = [
      for (final appointment in state)
        if (appointment.id == appointmentId)
          appointment.copyWith(
            status: AppointmentStatus.cancelled,
            cancelReason: reason,
            cancelComment: comment,
          )
        else
          appointment,
    ];
  }

  void addReview(
    String appointmentId, {
    required int stars,
    required String comment,
  }) {
    state = [
      for (final appointment in state)
        if (appointment.id == appointmentId)
          appointment.copyWith(
            reviewed: true,
            reviewStars: stars,
            reviewComment: comment,
          )
        else
          appointment,
    ];
  }

  String createScheduledAppointment(ScheduleDraft draft) {
    final appointmentId = 'scheduled-${DateTime.now().microsecondsSinceEpoch}';
    final appointment = AppointmentEntry(
      id: appointmentId,
      doctorId: draft.doctorId,
      status: AppointmentStatus.upcoming,
      dateLabel: draft.selectedDay.fullLabel,
      timeLabel: '${draft.selectedDay.weekday}, ${draft.selectedTime}',
      bookingForSelf: draft.bookingForSelf,
      patientName: draft.patientName,
      patientAge: draft.patientAge,
      patientGender: draft.patientGender,
      problemDescription: draft.problemDescription.isEmpty
          ? 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ea commodo consequat.'
          : draft.problemDescription,
    );

    state = [appointment, ...state];
    return appointmentId;
  }
}

class ScheduleDraftNotifier extends StateNotifier<ScheduleDraft> {
  ScheduleDraftNotifier(super.state);

  void selectMonth(int index) {
    state = state.copyWith(selectedMonthIndex: index);
  }

  void selectCalendarDay(int dayNumber) {
    state = state.copyWith(selectedCalendarDay: dayNumber);
  }

  void selectWeekDay(ScheduleDayOption day) {
    state = state.copyWith(
      selectedDay: day,
      selectedCalendarDay: day.dayNumber,
    );
  }

  void selectTime(String time) {
    state = state.copyWith(selectedTime: time);
  }

  void setBookingForSelf(bool value) {
    state = state.copyWith(bookingForSelf: value);
  }

  void updatePatientName(String value) {
    state = state.copyWith(patientName: value);
  }

  void updatePatientAge(String value) {
    state = state.copyWith(patientAge: value);
  }

  void updatePatientGender(PatientGender gender) {
    state = state.copyWith(patientGender: gender);
  }

  void updateProblemDescription(String value) {
    state = state.copyWith(problemDescription: value);
  }
}

AppointmentEntry? findAppointmentById(
  List<AppointmentEntry> appointments,
  String appointmentId,
) {
  for (final appointment in appointments) {
    if (appointment.id == appointmentId) {
      return appointment;
    }
  }

  return null;
}
