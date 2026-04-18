import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_index.dart';
import '../../../../shared/widgets/teacher_card.dart';
import '../providers/select_date_provider.dart';
import '../providers/teacher_provider.dart';
import '../widgets/home_page/events_mock.dart';
import '../widgets/home_page/header_widget.dart';
import '../widgets/home_page/timeline.dart';
import '../widgets/home_page/week_calendar.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final selectedDateWithoutTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );
    final eventsForDay = eventsMock[selectedDateWithoutTime] ?? [];

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
                        // print(date);
                      },
                    ),
                    SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      height: 140,
                      child: Timeline(
                        selectedDate: selectedDateWithoutTime,
                        events: {selectedDateWithoutTime: eventsForDay},
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
                      data: (teachers) => Column(
                        spacing: 10,
                        children: [
                          for (final teacher in teachers.take(4))
                            TeacherCard(
                              name: teacher.name,
                              description: teacher.specialty,
                              rating: teacher.rating,
                              comments: teacher.reviews,
                              imagePath: teacher.imagePath,
                              teacherId: teacher.id,
                            ),
                        ],
                      ),
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
