import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_index.dart';
import '../providers/select_date_provider.dart';
import '../widgets/events_mock.dart';
import '../widgets/header_widget.dart';
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
        child: Column(
          children: [
            HeaderWidget(),
            SizedBox(height: 16),
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
                children: [
                  Container(
                    padding: EdgeInsetsGeometry.only(
                        left: 13,
                        right: 9,
                        top: 8,
                        bottom: 6
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.signUpButtonBlue,
                      borderRadius: BorderRadius.circular(17),

                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          child: CircleAvatar(
                            backgroundImage: AssetImage(AppImages.exampleAvatar),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Dr. Olivia Turner, M.D.',
                                      style: AppStyles.leagueSpartan14,
                                    ),
                                    Text(
                                      'Dermato-Endocrinology',
                                      style: AppStyles.leagueSpartan12W300,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 4,),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 7,
                                      vertical: 4
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(13),
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.star_border, size: 14,
                                          color: AppColors.welcomeBlue,
                                        ),
                                        SizedBox(width: 6,),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 2.0),
                                          child: Text('4,5', style: AppStyles.leagueSpartan12W300.copyWith(
                                            color: AppColors.welcomeBlue,
                                          ),),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
