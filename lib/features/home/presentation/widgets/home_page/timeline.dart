import 'package:flutter/material.dart';
import 'time_slot.dart';

class Timeline extends StatelessWidget {
  final DateTime selectedDate;
  final Map<DateTime, List<Event>> events;

  const Timeline({super.key, required this.selectedDate, required this.events});

  @override
  Widget build(BuildContext context) {
    final dayEvents = events[selectedDate] ?? [];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(32)),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 12,
        itemBuilder: (_, i) {
          final hour = 9 + i;
          final event = dayEvents
              .where((e) => e.hour == hour)
              .cast<Event?>()
              .firstOrNull;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: TimeSlot(hour: hour, event: event),
          );
        },
      ),
    );
  }
}
