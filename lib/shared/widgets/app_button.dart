import 'package:flutter/material.dart';
import '../../../../core/constants/app_index.dart';

class AppButton extends StatelessWidget {
  final String title;
  final Color? backgroundButtonColor;
  final Color? textColor;
  final VoidCallback onPressed;
  const AppButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.backgroundButtonColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: backgroundButtonColor ?? AppColors.welcomeBlue,
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          title,
          style: AppStyles.leagueSpartan24.copyWith(
            color: textColor ?? Colors.white,
          ),
        ),
      ),
    );
  }
}
