import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medicity_app/core/constants/app_index.dart';

class ProfileTopBar extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final VoidCallback? onBackTap;
  final Color backgroundColor;
  final Color titleColor;
  final Color iconColor;

  const ProfileTopBar({
    super.key,
    required this.title,
    this.trailing,
    this.onBackTap,
    this.backgroundColor = Colors.white,
    this.titleColor = const Color(0xFF2260FF),
    this.iconColor = const Color(0xFF2260FF),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap:
              onBackTap ??
              () {
                if (Navigator.of(context).canPop()) {
                  context.pop();
                  return;
                }
                context.goNamed(AppRouteNames.homePage);
              },
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: iconColor,
              size: 24,
            ),
          ),
        ),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: AppStyles.leagueSpartan24.copyWith(
              color: titleColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(
          width: 40,
          child: Align(
            alignment: Alignment.centerRight,
            child: trailing ?? const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}

class ProfileAvatar extends StatelessWidget {
  final String imagePath;
  final double radius;
  final IconData actionIcon;
  final VoidCallback? onActionTap;

  const ProfileAvatar({
    super.key,
    required this.imagePath,
    this.radius = 58,
    this.actionIcon = Icons.edit_outlined,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(radius: radius, backgroundImage: AssetImage(imagePath)),
        Positioned(
          right: -4,
          bottom: 10,
          child: InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: onActionTap,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.welcomeBlue,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: Icon(actionIcon, color: Colors.white, size: 18),
            ),
          ),
        ),
      ],
    );
  }
}

class ProfileMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const ProfileMenuTile({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.signUpButtonBlue,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.welcomeBlue, size: 26),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                title,
                style: AppStyles.leagueSpartan20.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.signUpButtonBlue,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hintText;
  final TextInputType? keyboardType;

  const ProfileFormField({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppStyles.leagueSpartan20.copyWith(
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: AppStyles.leagueSpartan20.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.fillColor,
            hintText: hintText,
            hintStyle: AppStyles.leagueSpartan20.copyWith(
              color: AppColors.hintColor,
              fontWeight: FontWeight.w400,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}

class ProfilePrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const ProfilePrimaryButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 28),
        decoration: BoxDecoration(
          color: AppColors.welcomeBlue,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppStyles.leagueSpartan24.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: AppColors.welcomeBlue, size: 34),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                title,
                style: AppStyles.leagueSpartan20.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.welcomeBlue,
              size: 34,
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationSwitchTile extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const NotificationSwitchTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: AppStyles.leagueSpartan20.copyWith(
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Transform.scale(
            scale: 0.94,
            child: CupertinoSwitch(
              value: value,
              onChanged: onChanged,
              activeTrackColor: AppColors.welcomeBlue,
              inactiveTrackColor: AppColors.signUpButtonBlue,
              thumbColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class HelpTabButton extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const HelpTabButton({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.welcomeBlue
                : AppColors.signUpButtonBlue,
            borderRadius: BorderRadius.circular(999),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: AppStyles.leagueSpartan16.copyWith(
              color: selected ? Colors.white : AppColors.welcomeBlue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class HelpTagChip extends StatelessWidget {
  final String label;
  final bool selected;

  const HelpTagChip({super.key, required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? AppColors.welcomeBlue : AppColors.signUpButtonBlue,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppStyles.leagueSpartan12W600.copyWith(
          color: selected ? Colors.white : AppColors.welcomeBlue,
        ),
      ),
    );
  }
}
