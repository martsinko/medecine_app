import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medicity_app/core/constants/app_index.dart';

class WeekCalendar extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onSelect;

  const WeekCalendar({
    super.key,
    required this.selectedDate,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final start = selectedDate.subtract(
      Duration(days: selectedDate.weekday - 1),
    );

    return SizedBox(
      height: 82,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 7,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final date = start.add(Duration(days: i));
          final isSelected = _sameDay(date, selectedDate);

          return GestureDetector(
            onTap: () => onSelect(date),
            child: Container(
              width: 54,
              padding: EdgeInsets.only(top: 17, bottom: 12),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF2D66F6) : Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${date.day}',
                    style: AppStyles.leagueSpartan24.copyWith(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),

                  Text(
                    DateFormat('EEE').format(date).toUpperCase(),
                    style: AppStyles.leagueSpartan12W300.copyWith(
                      fontSize: 14,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
