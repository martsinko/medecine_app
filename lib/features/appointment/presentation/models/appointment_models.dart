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
    this.problemDescription = '',
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
  final int? month;
  final int? year;

  const ScheduleDayOption({
    required this.dayNumber,
    required this.weekday,
    required this.fullLabel,
    this.month,
    this.year,
  });

  factory ScheduleDayOption.fromIsoDate(String isoDate) {
    final date = _scheduleIsoDateFormat.parse(isoDate);
    return ScheduleDayOption(
      dayNumber: date.day,
      weekday: _scheduleWeekdayFormat.format(date).toUpperCase(),
      fullLabel:
          '${_scheduleMonthDayFormat.format(date)}, ${_scheduleYearFormat.format(date)}',
      month: date.month,
      year: date.year,
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

ScheduleDraft defaultScheduleDraft(String doctorId) {
  final today = DateTime.now();
  final selectedDate = DateTime(today.year, today.month, today.day);
  return ScheduleDraft(
    doctorId: doctorId,
    selectedMonthIndex: 0,
    selectedCalendarDay: selectedDate.day,
    selectedDay: ScheduleDayOption.fromIsoDate(
      _scheduleIsoDateFormat.format(selectedDate),
    ),
    selectedTime: _scheduleTimeOutputFormat.format(
      _scheduleTimeInputFormat.parse('10:00'),
    ),
    bookingForSelf: true,
    patientName: '',
    patientAge: '',
    patientGender: PatientGender.female,
    problemDescription: '',
  );
}

final DateFormat _scheduleIsoDateFormat = DateFormat('yyyy-MM-dd');
final DateFormat _scheduleWeekdayFormat = DateFormat('E');
final DateFormat _scheduleMonthFormat = DateFormat('MMMM');
final DateFormat _scheduleMonthDayFormat = DateFormat('MMMM d');
final DateFormat _scheduleYearFormat = DateFormat('yyyy');
final DateFormat _scheduleTimeInputFormat = DateFormat('HH:mm');
final DateFormat _scheduleTimeOutputFormat = DateFormat('h:mm a');

List<String> localizedWeekdayCodes() {
  final monday = DateTime(2026, 1, 5);
  return [
    for (int index = 0; index < DateTime.daysPerWeek; index++)
      _scheduleWeekdayFormat
          .format(monday.add(Duration(days: index)))
          .toUpperCase(),
  ];
}

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
  return _scheduleMonthFormat.format(baseScheduleMonth(availableDates));
}

DateTime baseScheduleMonth(List<String> availableDates) {
  if (availableDates.isEmpty) {
    final now = DateTime.now();
    return DateTime(now.year, now.month);
  }

  final firstDate = _scheduleIsoDateFormat.parse(availableDates.first);
  return DateTime(firstDate.year, firstDate.month);
}

DateTime displayedScheduleMonth(List<String> availableDates, int monthOffset) {
  final baseMonth = baseScheduleMonth(availableDates);
  return DateTime(baseMonth.year, baseMonth.month + monthOffset);
}

String scheduleMonthLabelFor(DateTime month) {
  return _scheduleMonthFormat.format(month);
}

Set<int> availableCalendarDayNumbers(
  List<String> availableDates, {
  DateTime? month,
}) {
  return {
    for (final isoDate in availableDates)
      if (month == null ||
          (_scheduleIsoDateFormat.parse(isoDate).year == month.year &&
              _scheduleIsoDateFormat.parse(isoDate).month == month.month))
        _scheduleIsoDateFormat.parse(isoDate).day,
  };
}

List<int?> buildMonthCalendarGridFor(DateTime month) {
  final firstDayOfMonth = DateTime(month.year, month.month, 1);
  final leadingEmptyDays = firstDayOfMonth.weekday - DateTime.monday;
  final daysInMonth = DateTime(month.year, month.month + 1, 0).day;

  return [
    for (int i = 0; i < leadingEmptyDays; i++) null,
    for (int day = 1; day <= daysInMonth; day++) day,
  ];
}

List<int?> buildMonthCalendarGrid(List<String> availableDates) {
  return buildMonthCalendarGridFor(baseScheduleMonth(availableDates));
}

bool isSelectedScheduleDay({
  required ScheduleDayOption selectedDay,
  required int? calendarDay,
  required DateTime displayedMonth,
}) {
  if (calendarDay == null) {
    return false;
  }

  return selectedDay.dayNumber == calendarDay &&
      selectedDay.month == displayedMonth.month &&
      selectedDay.year == displayedMonth.year;
}
