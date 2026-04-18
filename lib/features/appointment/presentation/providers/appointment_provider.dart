import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicity_app/core/firebase/firebase_providers.dart';
import 'package:medicity_app/features/appointment/data/appointment_repository.dart';
import 'package:medicity_app/features/profile/presentation/providers/profile_provider.dart';

import '../data/schedule_mock.dart';
import '../models/appointment_models.dart';

final appointmentRepositoryProvider = Provider<AppointmentRepository>((ref) {
  return AppointmentRepository(firestore: ref.watch(firestoreProvider));
});

final appointmentsProvider = StreamProvider<List<AppointmentEntry>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) {
    return Stream.value(const <AppointmentEntry>[]);
  }

  return ref.watch(appointmentRepositoryProvider).watchAppointments(userId);
});

final appointmentActionProvider =
    StateNotifierProvider<AppointmentActionNotifier, AsyncValue<void>>((ref) {
      return AppointmentActionNotifier(ref);
    });

final unavailableTimeSlotsProvider =
    FutureProvider.family<List<String>, ({String doctorId, String dateLabel})>((ref, params) async {
      final userId = ref.read(currentUserIdProvider);
      if (userId == null) {
        return [];
      }
      return ref.read(appointmentRepositoryProvider).getUnavailableTimeSlots(
        doctorId: params.doctorId,
        dateLabel: params.dateLabel,
      );
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

class AppointmentActionNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  AppointmentActionNotifier(this._ref) : super(const AsyncData(null));

  Future<void> markAsComplete(String appointmentId) {
    return _updateAppointment(appointmentId, {
      'status': AppointmentStatus.complete.name,
    });
  }

  Future<void> cancelAppointment(
    String appointmentId, {
    required CancelReason reason,
    required String comment,
  }) {
    return _updateAppointment(appointmentId, {
      'status': AppointmentStatus.cancelled.name,
      'cancelReason': reason.name,
      'cancelComment': comment,
    });
  }

  Future<void> addReview(
    String appointmentId, {
    required int stars,
    required String comment,
  }) {
    return _updateAppointment(appointmentId, {
      'reviewed': true,
      'reviewStars': stars,
      'reviewComment': comment,
    });
  }

  Future<String> createScheduledAppointment(ScheduleDraft draft) async {
    final userId = _ref.read(currentUserIdProvider);
    final appointmentId = 'scheduled-${DateTime.now().microsecondsSinceEpoch}';

    if (userId == null) {
      state = AsyncError(
        StateError('User is not logged in.'),
        StackTrace.current,
      );
      return appointmentId;
    }

    final hasConflict = await _ref.read(appointmentRepositoryProvider).hasConflictBooking(
      userId: userId,
      doctorId: draft.doctorId,
      dateLabel: draft.selectedDay.fullLabel,
      timeLabel: draft.selectedTime,
    );
    if (hasConflict) {
      state = AsyncError(
        StateError('This time slot is already booked. Please select another time.'),
        StackTrace.current,
      );
      return appointmentId;
    }

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

    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _ref
          .read(appointmentRepositoryProvider)
          .setAppointment(appointment, userId),
    );
    return appointmentId;
  }

  Future<void> _updateAppointment(
    String appointmentId,
    Map<String, dynamic> data,
  ) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _ref
          .read(appointmentRepositoryProvider)
          .updateAppointment(appointmentId, data),
    );
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
