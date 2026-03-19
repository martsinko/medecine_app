import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_index.dart';
import '../../../../shared/widgets/small_button.dart';
import '../../../../shared/widgets/teacher_card.dart';
import '../providers/select_date_provider.dart';
import '../widgets/events_mock.dart';
import '../widgets/header_widget.dart';
import '../widgets/info_container.dart';
import '../widgets/timeline.dart';
import '../widgets/week_calendar.dart';

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
                        print(date);
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
              SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  spacing: 10,
                  children: List.generate(4, (e) =>
                      TeacherCard(
                    name: 'Dr. Olivia Turner, M.D.',
                    description: 'Dermato-Endocrinology',
                    rating: 5,
                    comments: 60,
                  ))
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

