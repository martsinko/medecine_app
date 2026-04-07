import 'package:flutter/material.dart';
import 'package:medicity_app/core/constants/app_index.dart';

class HeaderButton extends StatelessWidget {
  final String imagePath;
  final String title;
  final VoidCallback onTap;

  const HeaderButton({
    super.key,
    required this.imagePath,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(imagePath, height: 22),
            const SizedBox(height: 6),
            Text(
              title,
              style: AppStyles.leagueSpartan12W300.copyWith(
                color: AppColors.welcomeBlue,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
