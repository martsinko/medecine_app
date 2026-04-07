import 'package:flutter/material.dart';

import '../../../../../core/constants/app_index.dart';

class InfoContainer extends StatelessWidget {
  final String title;
  final IconData icon;
  const InfoContainer({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 15, color: AppColors.welcomeBlue),
          SizedBox(width: 4),
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Text(
              title,
              style: AppStyles.leagueSpartan12W300.copyWith(
                color: AppColors.welcomeBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
