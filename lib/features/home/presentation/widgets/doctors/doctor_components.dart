import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medicity_app/core/constants/app_index.dart';
import 'package:medicity_app/shared/widgets/adaptive_avatar.dart';

import '../../models/doctor_profile.dart';

enum DoctorsFilterHighlight { none, rating, favorite }

class DoctorsTopBar extends StatelessWidget {
  final String title;

  const DoctorsTopBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TopCircleButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onTap: () {
            if (Navigator.of(context).canPop()) {
              context.pop();
              return;
            }
            context.goNamed(AppRouteNames.homePage);
          },
        ),
        const Spacer(),
        Text(
          title,
          style: AppStyles.leagueSpartan24.copyWith(
            color: AppColors.welcomeBlue,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        const _TopCircleButton(icon: Icons.search_rounded),
        const SizedBox(width: 8),
        const _TopCircleButton(icon: Icons.tune_rounded),
      ],
    );
  }
}

class DoctorsFilterRow extends StatelessWidget {
  final DoctorsFilterHighlight highlight;
  final VoidCallback? onRatingTap;
  final VoidCallback? onFavoriteTap;
  final bool showGenderFilters;
  final bool favoriteSelected;
  final DoctorGender? selectedGender;
  final VoidCallback? onFemaleTap;
  final VoidCallback? onMaleTap;

  const DoctorsFilterRow({
    super.key,
    this.highlight = DoctorsFilterHighlight.none,
    this.onRatingTap,
    this.onFavoriteTap,
    this.showGenderFilters = false,
    this.favoriteSelected = false,
    this.selectedGender,
    this.onFemaleTap,
    this.onMaleTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Text(
            'Sort By',
            style: AppStyles.leagueSpartan12W300.copyWith(
              color: const Color(0xFF444444),
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 10),
          _LabelFilterChip(label: 'A - Z', selected: true, onTap: () {}),
          const SizedBox(width: 8),
          _IconFilterChip(
            icon: Icons.star_rounded,
            selected: highlight == DoctorsFilterHighlight.rating,
            onTap: onRatingTap,
          ),
          const SizedBox(width: 6),
          _IconFilterChip(
            icon: Icons.favorite_rounded,
            selected:
                favoriteSelected ||
                highlight == DoctorsFilterHighlight.favorite,
            onTap: onFavoriteTap,
          ),
          const SizedBox(width: 6),
          if (showGenderFilters) ...[
            _IconFilterChip(
              icon: Icons.female_rounded,
              selected: selectedGender == DoctorGender.female,
              onTap: onFemaleTap,
            ),
            const SizedBox(width: 6),
            _IconFilterChip(
              icon: Icons.male_rounded,
              selected: selectedGender == DoctorGender.male,
              onTap: onMaleTap,
            ),
          ] else ...[
            const _IconFilterChip(icon: Icons.location_on_rounded),
            const SizedBox(width: 6),
            const _IconFilterChip(icon: Icons.medical_services_rounded),
          ],
        ],
      ),
    );
  }
}

class DoctorCompactCard extends StatelessWidget {
  final DoctorProfile doctor;
  final VoidCallback? onInfoTap;
  final VoidCallback? onCalendarTap;
  final VoidCallback? onDetailsTap;
  final VoidCallback? onFavoriteTap;

  const DoctorCompactCard({
    super.key,
    required this.doctor,
    this.onInfoTap,
    this.onCalendarTap,
    this.onDetailsTap,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.signUpButtonBlue,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 46,
            backgroundColor: Colors.transparent,
            child: AdaptiveAvatar(imageSource: doctor.imagePath, radius: 46),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.name,
                  style: AppStyles.leagueSpartan16.copyWith(
                    color: AppColors.welcomeBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  doctor.specialty,
                  style: AppStyles.leagueSpartan12W300.copyWith(
                    color: const Color(0xFF373737),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    PrimaryPillButton(label: 'Info', onTap: onInfoTap),
                    const Spacer(),
                    RoundActionButton(
                      icon: Icons.calendar_month_rounded,
                      onTap: onCalendarTap,
                    ),
                    const SizedBox(width: 4),
                    RoundActionButton(
                      icon: Icons.info_outline_rounded,
                      onTap: onDetailsTap,
                    ),
                    const SizedBox(width: 4),
                    const RoundActionButton(icon: Icons.question_mark_rounded),
                    const SizedBox(width: 4),
                    RoundActionButton(
                      icon: Icons.favorite_rounded,
                      selected: doctor.isFavorite,
                      onTap: onFavoriteTap,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MetricBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const MetricBadge({
    super.key,
    required this.icon,
    required this.label,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color fill = backgroundColor ?? Colors.white;
    final Color color = foregroundColor ?? AppColors.welcomeBlue;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppStyles.leagueSpartan12W300.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class RoundActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool selected;

  const RoundActionButton({
    super.key,
    required this.icon,
    this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: selected ? AppColors.welcomeBlue : Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: selected ? Colors.white : AppColors.welcomeBlue,
          size: 16,
        ),
      ),
    );
  }
}

class PrimaryPillButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  const PrimaryPillButton({
    super.key,
    required this.label,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: AppColors.welcomeBlue,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: AppStyles.leagueSpartan12W600.copyWith(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppStyles.leagueSpartan16.copyWith(
        color: AppColors.welcomeBlue,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _TopCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _TopCircleButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: AppColors.signUpButtonBlue.withValues(alpha: 0.85),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: AppColors.welcomeBlue),
      ),
    );
  }
}

class _LabelFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const _LabelFilterChip({
    required this.label,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: selected ? AppColors.welcomeBlue : AppColors.signUpButtonBlue,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: AppStyles.leagueSpartan12W600.copyWith(
            color: selected ? Colors.white : AppColors.welcomeBlue,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _IconFilterChip extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback? onTap;

  const _IconFilterChip({
    required this.icon,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: selected ? AppColors.welcomeBlue : AppColors.signUpButtonBlue,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 14,
          color: selected ? Colors.white : AppColors.welcomeBlue,
        ),
      ),
    );
  }
}
