import 'package:flutter/material.dart';

import '../../../../core/constants/app_index.dart';

class CustomAuthButton extends StatelessWidget {
  final VoidCallback onTap;
  final String assetPath;
  const CustomAuthButton({
    super.key,
    required this.onTap,
    required this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        height: 50,
        width: 50,
        padding: EdgeInsets.all(11),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.signUpButtonBlue,
        ),
        child: Image.asset(assetPath),
      ),
    );
  }
}
