import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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

  factory AppointmentEntry.fromFirestore(String id, Map<String, dynamic> map) {
    return AppointmentEntry(
      id: id,
      doctorId: map['teacherId'] as String? ?? map['doctorId'] as String? ?? '',
      status: _statusFromString(map['status'] as String?),
      dateLabel: map['dateLabel'] as String? ?? '',
      timeLabel: map['timeLabel'] as String? ?? '',
      isFavorite: map['isFavorite'] as bool? ?? true,
      reviewed: map['reviewed'] as bool? ?? false,
      reviewComment: map['reviewComment'] as String?,
      reviewStars: (map['reviewStars'] as num?)?.toInt() ?? 4,
      cancelReason: _reasonFromString(map['cancelReason'] as String?),
      cancelComment: map['cancelComment'] as String?,
      bookingForSelf: map['bookingForSelf'] as bool? ?? true,
      patientName: map['patientName'] as String? ?? '',
      patientAge: map['patientAge'] as String? ?? '',
      patientGender: _patientGenderFromString(map['patientGender'] as String?),
      problemDescription: map['problemDescription'] as String? ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'teacherId': doctorId,
      'status': status.name,
      'dateLabel': dateLabel,
      'timeLabel': timeLabel,
      'isFavorite': isFavorite,
      'reviewed': reviewed,
      'reviewComment': reviewComment,
      'reviewStars': reviewStars,
      'cancelReason': cancelReason?.name,
      'cancelComment': cancelComment,
      'bookingForSelf': bookingForSelf,
      'patientName': patientName,
      'patientAge': patientAge,
      'patientGender': patientGender.name,
      'problemDescription': problemDescription,
      'updatedAt': Timestamp.now(),
    };
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

  factory ScheduleDayOption.fromIsoDate(String isoDate) {
    final date = _scheduleIsoDateFormat.parse(isoDate);
    return ScheduleDayOption(
      dayNumber: date.day,
      weekday: _scheduleWeekdayFormat.format(date).toUpperCase(),
      fullLabel:
          '${_scheduleMonthDayFormat.format(date)}, ${_scheduleYearFormat.format(date)}',
    );
  }
}

AppointmentStatus _statusFromString(String? value) {
  return switch (value) {
    'upcoming' => AppointmentStatus.upcoming,
    'cancelled' => AppointmentStatus.cancelled,
    _ => AppointmentStatus.complete,
  };
}

CancelReason? _reasonFromString(String? value) {
  return switch (value) {
    'rescheduling' => CancelReason.rescheduling,
    'weatherConditions' => CancelReason.weatherConditions,
    'unexpectedWork' => CancelReason.unexpectedWork,
    'others' => CancelReason.others,
    _ => null,
  };
}

PatientGender _patientGenderFromString(String? value) {
  return switch (value) {
    'male' => PatientGender.male,
    'other' => PatientGender.other,
    _ => PatientGender.female,
  };
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

final DateFormat _scheduleIsoDateFormat = DateFormat('yyyy-MM-dd');
final DateFormat _scheduleWeekdayFormat = DateFormat('E');
final DateFormat _scheduleMonthFormat = DateFormat('MMMM');
final DateFormat _scheduleMonthDayFormat = DateFormat('MMMM d');
final DateFormat _scheduleYearFormat = DateFormat('yyyy');
final DateFormat _scheduleTimeInputFormat = DateFormat('HH:mm');
final DateFormat _scheduleTimeOutputFormat = DateFormat('h:mm a');

List<ScheduleDayOption> buildScheduleDayOptions(List<String> availableDates) {
  return [
    for (final isoDate in availableDates)
      ScheduleDayOption.fromIsoDate(isoDate),
  ];
}

List<String> buildScheduleTimes(List<String> timeSlots) {
  return [
    for (final slot in timeSlots)
      _scheduleTimeOutputFormat.format(_scheduleTimeInputFormat.parse(slot)),
  ];
}

String scheduleMonthLabel(List<String> availableDates) {
  if (availableDates.isEmpty) {
    return 'Month';
  }

  return _scheduleMonthFormat.format(
    _scheduleIsoDateFormat.parse(availableDates.first),
  );
}

Set<int> availableCalendarDayNumbers(List<String> availableDates) {
  return {
    for (final isoDate in availableDates)
      _scheduleIsoDateFormat.parse(isoDate).day,
  };
}

List<int?> buildMonthCalendarGrid(List<String> availableDates) {
  if (availableDates.isEmpty) {
    return List<int?>.generate(31, (index) => index + 1);
  }

  final firstDate = _scheduleIsoDateFormat.parse(availableDates.first);
  final firstDayOfMonth = DateTime(firstDate.year, firstDate.month, 1);
  final leadingEmptyDays = firstDayOfMonth.weekday - DateTime.monday;
  final daysInMonth = DateTime(firstDate.year, firstDate.month + 1, 0).day;

  return [
    for (int i = 0; i < leadingEmptyDays; i++) null,
    for (int day = 1; day <= daysInMonth; day++) day,
  ];
}
