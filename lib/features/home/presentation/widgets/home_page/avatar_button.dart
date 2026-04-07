import 'package:flutter/material.dart';
import '../../../../../core/constants/app_index.dart';

class AvatarButton extends StatelessWidget {
  final String? imagePath;
  const AvatarButton({super.key, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 36,
        width: 36,
        padding: EdgeInsets.all(7),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.signUpButtonBlue,
        ),
        child: Image.asset(imagePath ?? AppIcons.settingsIcon),
      ),
    );
  }
}
