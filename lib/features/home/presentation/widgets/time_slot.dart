import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:flutter/material.dart';
import 'package:medicity_app/core/constants/app_index.dart';

import 'event_card.dart';

class TimeSlot extends StatelessWidget {
  final int hour;
  final Event? event;

  const TimeSlot({super.key, required this.hour, this.event});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: event != null ? 100 : 30,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 44,
            child: Text(
              '${hour % 12 == 0 ? 12 : hour % 12} ${hour < 12 ? 'AM' : 'PM'}',
              style: AppStyles.leagueSpartan12W300.copyWith(
                color: AppColors.welcomeBlue,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                if (event == null)
                  Positioned(
                    top: 13,
                    left: 0,
                    right: 0,
                    child: DottedDashedLine(
                      height: 0,
                      width: 0,
                      axis: Axis.horizontal,
                      dashColor: AppColors.welcomeBlue,
                    ),
                  ),
                if (event != null)
                  Positioned(
                    top: 13,
                    left: 0,
                    right: 16,
                    child: EventCard(event!),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Event {
  final String title;
  final String description;
  final int hour;

  Event({required this.title, required this.description, required this.hour});
}
