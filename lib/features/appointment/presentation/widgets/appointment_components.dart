import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medicity_app/core/constants/app_index.dart';
import 'package:medicity_app/features/home/presentation/models/doctor_profile.dart';

import '../models/appointment_models.dart';

class AppointmentTopBar extends StatelessWidget {
  final String title;

  const AppointmentTopBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: () {
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
              color: AppColors.welcomeBlue,
              size: 24,
            ),
          ),
        ),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: AppStyles.leagueSpartan24.copyWith(
              color: AppColors.welcomeBlue,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 40),
      ],
    );
  }
}

class ScheduleFlowHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onTitleTap;

  const ScheduleFlowHeader({super.key, required this.title, this.onTitleTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: () => context.pop(),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.welcomeBlue,
              size: 24,
            ),
          ),
        ),
        const SizedBox(width: 8),
        InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: onTitleTap,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 170),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.welcomeBlue,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: AppStyles.leagueSpartan12W600.copyWith(fontSize: 15),
            ),
          ),
        ),
        const Spacer(),
        const ScheduleHeaderIcon(icon: Icons.phone_in_talk_outlined),
        const SizedBox(width: 6),
        const ScheduleHeaderIcon(icon: Icons.message_outlined),
        const SizedBox(width: 6),
        const ScheduleHeaderIcon(icon: Icons.support_agent_outlined),
        const SizedBox(width: 6),
        const ScheduleHeaderIcon(icon: Icons.question_mark_rounded),
        const SizedBox(width: 6),
        const ScheduleHeaderIcon(icon: Icons.favorite_rounded),
      ],
    );
  }
}

class ScheduleHeaderIcon extends StatelessWidget {
  final IconData icon;

  const ScheduleHeaderIcon({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: AppColors.signUpButtonBlue,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: AppColors.welcomeBlue, size: 16),
    );
  }
}

class AppointmentStatusTabs extends StatelessWidget {
  final AppointmentStatus selectedStatus;
  final ValueChanged<AppointmentStatus> onSelected;

  const AppointmentStatusTabs({
    super.key,
    required this.selectedStatus,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatusChip(
          label: 'Complete',
          selected: selectedStatus == AppointmentStatus.complete,
          onTap: () => onSelected(AppointmentStatus.complete),
        ),
        const SizedBox(width: 8),
        _StatusChip(
          label: 'Upcoming',
          selected: selectedStatus == AppointmentStatus.upcoming,
          onTap: () => onSelected(AppointmentStatus.upcoming),
        ),
        const SizedBox(width: 8),
        _StatusChip(
          label: 'Cancelled',
          selected: selectedStatus == AppointmentStatus.cancelled,
          onTap: () => onSelected(AppointmentStatus.cancelled),
        ),
      ],
    );
  }
}

class AppointmentDoctorHeader extends StatelessWidget {
  final DoctorProfile doctor;
  final Widget? trailing;

  const AppointmentDoctorHeader({
    super.key,
    required this.doctor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(radius: 34, backgroundImage: AssetImage(doctor.imagePath)),
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
              const SizedBox(height: 4),
              Text(
                doctor.specialty,
                style: AppStyles.leagueSpartan12W300.copyWith(fontSize: 14),
              ),
            ],
          ),
        ),
        trailing ?? const SizedBox.shrink(),
      ],
    );
  }
}

class InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const InfoPill({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.welcomeBlue),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppStyles.leagueSpartan12W300.copyWith(
              color: AppColors.welcomeBlue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class AppointmentActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool filled;

  const AppointmentActionButton({
    super.key,
    required this.label,
    required this.onTap,
    this.filled = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
        decoration: BoxDecoration(
          color: filled ? AppColors.welcomeBlue : Colors.white,
          borderRadius: BorderRadius.circular(999),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppStyles.leagueSpartan16.copyWith(
            color: filled ? Colors.white : AppColors.welcomeBlue,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class CircleIconAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const CircleIconAction({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.welcomeBlue, size: 18),
      ),
    );
  }
}

class StarRatingRow extends StatelessWidget {
  final int selectedStars;
  final ValueChanged<int>? onChanged;
  final bool includeFavorite;

  const StarRatingRow({
    super.key,
    required this.selectedStars,
    this.onChanged,
    this.includeFavorite = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (includeFavorite) ...[
          Icon(Icons.favorite_rounded, color: AppColors.welcomeBlue, size: 18),
          const SizedBox(width: 6),
        ],
        for (int i = 1; i <= 5; i++) ...[
          InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: onChanged == null ? null : () => onChanged!(i),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: Icon(
                i <= selectedStars
                    ? Icons.star_rounded
                    : Icons.star_border_rounded,
                color: AppColors.welcomeBlue,
                size: 20,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class ReasonOptionTile extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const ReasonOptionTile({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.signUpButtonBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.welcomeBlue, width: 1.5),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppColors.welcomeBlue,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: AppStyles.leagueSpartan16.copyWith(
                  color: const Color(0xFF454545),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _StatusChip({
    required this.label,
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
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.welcomeBlue
                : AppColors.signUpButtonBlue,
            borderRadius: BorderRadius.circular(999),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppStyles.leagueSpartan12W600.copyWith(
              color: selected ? Colors.white : AppColors.welcomeBlue,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
