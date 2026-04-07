import 'package:flutter/material.dart';
import 'package:medicity_app/core/constants/app_index.dart';
import 'package:medicity_app/features/home/presentation/widgets/home_page/time_slot.dart';

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard(this.event, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 14, top: 12, bottom: 12, right: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFDDE7FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        event.title,
                        style: AppStyles.leagueSpartan14,
                      ),
                    ),
                    Container(
                      height: 16,
                      width: 16,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.check,
                          color: AppColors.welcomeBlue,
                          size: 13,
                        ),
                      ),
                    ),
                    SizedBox(width: 4),
                    Container(
                      height: 16,
                      width: 16,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.close,
                          color: AppColors.welcomeBlue,
                          size: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  event.description,
                  style: AppStyles.leagueSpartan12W300.copyWith(height: 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
