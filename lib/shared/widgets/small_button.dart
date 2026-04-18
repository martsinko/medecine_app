import 'package:flutter/material.dart';

import '../../core/constants/app_index.dart';

class SmallButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final bool selected;
  const SmallButton({
    super.key,
    required this.onTap,
    required this.icon,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: 7,
            vertical: 5
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon, size: 12,
          color: selected ? AppColors.welcomeBlue : AppColors.hintColor,
        ),
      ),
    );
  }
}