import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:medicity_app/core/constants/app_index.dart';
import 'package:medicity_app/shared/widgets/teacher_card.dart';
import 'package:medicity_app/features/appointment/presentation/models/appointment_models.dart';
import 'package:medicity_app/features/appointment/presentation/providers/appointment_provider.dart';
import '../providers/select_date_provider.dart';
import '../providers/teacher_provider.dart';
import '../widgets/home_page/events_mock.dart';
import '../widgets/home_page/header_widget.dart';
import '../widgets/home_page/header_search_field.dart';
import '../widgets/home_page/timeline.dart';
import '../widgets/home_page/week_calendar.dart';
import '../widgets/home_page/time_slot.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final searchQuery = ref.watch(searchQueryProvider).toLowerCase();
    final selectedDateWithoutTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );
    final eventsForDay = eventsMock[selectedDateWithoutTime] ?? [];

    final appointmentsAsync = ref.watch(appointmentsProvider);
    final selectedMonth = selectedDateWithoutTime.month;
    final selectedDay = selectedDateWithoutTime.day;
    final selectedYear = selectedDateWithoutTime.year;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              HeaderWidget(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 18),
                color: AppColors.signUpButtonBlue,
                child: Column(
                  children: [
                    WeekCalendar(
                      selectedDate: selectedDate,
                      onSelect: (date) {
                        ref.read(selectedDateProvider.notifier).state = date;
                      },
                    ),
                    SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      height: 140,
                      child: appointmentsAsync.when(
                        data: (appointments) {
                          final dayAppointments = appointments
                              .where(
                                (a) =>
                                    a.status == AppointmentStatus.upcoming &&
                                    _matchesDate(
                                      a.dateLabel,
                                      selectedMonth,
                                      selectedDay,
                                      selectedYear,
                                    ),
                              )
                              .toList();

                          final events = dayAppointments.isEmpty
                              ? {selectedDateWithoutTime: eventsForDay}
                              : <DateTime, List<Event>>{};

                          if (dayAppointments.isNotEmpty) {
                            final teachersAsync = ref.read(teachersProvider);
                            events[selectedDateWithoutTime] = [
                              for (final appt in dayAppointments)
                                Event(
                                  title:
                                      teachersAsync.value
                                          ?.firstWhere(
                                            (t) => t.id == appt.doctorId,
                                            orElse: () =>
                                                teachersAsync.value!.first,
                                          )
                                          .name ??
                                      'Unknown',
                                  description:
                                      '${appt.timeLabel} - ${appt.patientName}',
                                  hour: _parseHour(appt.timeLabel),
                                ),
                            ];
                          }

                          return Timeline(
                            selectedDate: selectedDateWithoutTime,
                            events: dayAppointments.isEmpty
                                ? {selectedDateWithoutTime: eventsForDay}
                                : events,
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (_, __) => Timeline(
                          selectedDate: selectedDateWithoutTime,
                          events: {selectedDateWithoutTime: eventsForDay},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: ref
                    .watch(teachersProvider)
                    .when(
                      data: (teachers) {
                        final filteredTeachers = searchQuery.isEmpty
                            ? teachers.take(4).toList()
                            : teachers
                                  .where(
                                    (t) =>
                                        t.name.toLowerCase().contains(
                                          searchQuery,
                                        ) ||
                                        t.specialty.toLowerCase().contains(
                                          searchQuery,
                                        ),
                                  )
                                  .toList();

                        if (filteredTeachers.isEmpty) {
                          return Padding(
                            padding: EdgeInsets.all(24),
                            child: Text(
                              'No teachers found.',
                              style: AppStyles.leagueSpartan16,
                            ),
                          );
                        }

                        return Column(
                          spacing: 10,
                          children: [
                            for (final teacher in filteredTeachers)
                              TeacherCard(
                                name: teacher.name,
                                description: teacher.specialty,
                                rating: teacher.rating,
                                comments: teacher.reviews,
                                imagePath: teacher.imagePath,
                                teacherId: teacher.id,
                                isFavorite: teacher.isFavorite,
                              ),
                          ],
                        );
                      },
                      loading: () => const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      error: (error, stackTrace) => Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: Text(
                          'Failed to load teachers.',
                          style: AppStyles.leagueSpartan16,
                        ),
                      ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

bool _matchesDate(String dateLabel, int month, int day, int year) {
  final lower = dateLabel.toLowerCase();
  final monthNames = {
    'january': 1,
    'february': 2,
    'march': 3,
    'april': 4,
    'may': 5,
    'june': 6,
    'july': 7,
    'august': 8,
    'september': 9,
    'october': 10,
    'november': 11,
    'december': 12,
  };
  for (final m in monthNames.entries) {
    if (lower.contains(m.key) &&
        lower.contains(day.toString()) &&
        lower.contains(year.toString())) {
      return m.value == month;
    }
  }
  return lower.contains('$month/$day/$year') ||
      lower.contains('$month-$day-$year');
}

int _parseHour(String timeLabel) {
  final cleaned = timeLabel.replaceAll(RegExp(r'[^\d]'), '');
  if (cleaned.isEmpty) return 9;
  final hour =
      int.tryParse(cleaned.substring(0, cleaned.length > 1 ? 2 : 1)) ?? 9;
  if (timeLabel.toLowerCase().contains('pm') && hour < 12) return hour + 12;
  if (timeLabel.toLowerCase().contains('am') && hour == 12) return 0;
  return hour;
}
