enum AppointmentStatus { complete, upcoming, cancelled }

enum CancelReason { rescheduling, weatherConditions, unexpectedWork, others }

enum PatientGender { male, female, other }

class AppointmentEntry {
  final String id;
  final String doctorId;
  final AppointmentStatus status;
  final String dateLabel;
  final String timeLabel;
  final bool isFavorite;
  final bool reviewed;
  final String? reviewComment;
  final int reviewStars;
  final CancelReason? cancelReason;
  final String? cancelComment;
  final bool bookingForSelf;
  final String patientName;
  final String patientAge;
  final PatientGender patientGender;
  final String problemDescription;

  const AppointmentEntry({
    required this.id,
    required this.doctorId,
    required this.status,
    required this.dateLabel,
    required this.timeLabel,
    this.isFavorite = true,
    this.reviewed = false,
    this.reviewComment,
    this.reviewStars = 4,
    this.cancelReason,
    this.cancelComment,
    this.bookingForSelf = true,
    this.patientName = 'Jane Doe',
    this.patientAge = '30',
    this.patientGender = PatientGender.female,
    this.problemDescription =
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ea commodo consequat.',
  });

  AppointmentEntry copyWith({
    AppointmentStatus? status,
    bool? isFavorite,
    bool? reviewed,
    String? reviewComment,
    int? reviewStars,
    CancelReason? cancelReason,
    String? cancelComment,
    bool? bookingForSelf,
    String? patientName,
    String? patientAge,
    PatientGender? patientGender,
    String? problemDescription,
  }) {
    return AppointmentEntry(
      id: id,
      doctorId: doctorId,
      status: status ?? this.status,
      dateLabel: dateLabel,
      timeLabel: timeLabel,
      isFavorite: isFavorite ?? this.isFavorite,
      reviewed: reviewed ?? this.reviewed,
      reviewComment: reviewComment ?? this.reviewComment,
      reviewStars: reviewStars ?? this.reviewStars,
      cancelReason: cancelReason ?? this.cancelReason,
      cancelComment: cancelComment ?? this.cancelComment,
      bookingForSelf: bookingForSelf ?? this.bookingForSelf,
      patientName: patientName ?? this.patientName,
      patientAge: patientAge ?? this.patientAge,
      patientGender: patientGender ?? this.patientGender,
      problemDescription: problemDescription ?? this.problemDescription,
    );
  }
}

class ScheduleDayOption {
  final int dayNumber;
  final String weekday;
  final String fullLabel;

  const ScheduleDayOption({
    required this.dayNumber,
    required this.weekday,
    required this.fullLabel,
  });
}

class ScheduleDraft {
  final String doctorId;
  final int selectedMonthIndex;
  final int selectedCalendarDay;
  final ScheduleDayOption selectedDay;
  final String selectedTime;
  final bool bookingForSelf;
  final String patientName;
  final String patientAge;
  final PatientGender patientGender;
  final String problemDescription;

  const ScheduleDraft({
    required this.doctorId,
    required this.selectedMonthIndex,
    required this.selectedCalendarDay,
    required this.selectedDay,
    required this.selectedTime,
    required this.bookingForSelf,
    required this.patientName,
    required this.patientAge,
    required this.patientGender,
    required this.problemDescription,
  });

  ScheduleDraft copyWith({
    String? doctorId,
    int? selectedMonthIndex,
    int? selectedCalendarDay,
    ScheduleDayOption? selectedDay,
    String? selectedTime,
    bool? bookingForSelf,
    String? patientName,
    String? patientAge,
    PatientGender? patientGender,
    String? problemDescription,
  }) {
    return ScheduleDraft(
      doctorId: doctorId ?? this.doctorId,
      selectedMonthIndex: selectedMonthIndex ?? this.selectedMonthIndex,
      selectedCalendarDay: selectedCalendarDay ?? this.selectedCalendarDay,
      selectedDay: selectedDay ?? this.selectedDay,
      selectedTime: selectedTime ?? this.selectedTime,
      bookingForSelf: bookingForSelf ?? this.bookingForSelf,
      patientName: patientName ?? this.patientName,
      patientAge: patientAge ?? this.patientAge,
      patientGender: patientGender ?? this.patientGender,
      problemDescription: problemDescription ?? this.problemDescription,
    );
  }
}
