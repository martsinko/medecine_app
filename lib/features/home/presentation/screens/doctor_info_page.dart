import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medicity_app/core/constants/app_index.dart';
import 'package:medicity_app/core/localization/app_localizations.dart';
import 'package:medicity_app/features/home/presentation/models/doctor_profile.dart';
import 'package:medicity_app/features/profile/presentation/providers/profile_provider.dart';
import 'package:medicity_app/shared/widgets/adaptive_avatar.dart';

import '../providers/teacher_provider.dart';
import '../widgets/teachers/teacher_components.dart';

class DoctorInfoPage extends ConsumerWidget {
  final String teacherId;

  const DoctorInfoPage({super.key, required this.teacherId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teacherAsync = ref.watch(teacherByIdProvider(teacherId));

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: teacherAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text('${context.tr('error')}: $e')),
          data: (teacher) {
            if (teacher == null) {
              return Center(child: Text(context.tr('teacherNotFound')));
            }
            return _buildContent(context, ref, teacher);
          },
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    DoctorProfile teacher,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
      child: ListView(
        padding: const EdgeInsets.only(bottom: 120),
        children: [
          _TeacherInfoTopBar(
            onSearchTap: () => context.goNamed(AppRouteNames.teachersPage),
            onFilterTap: () => context.goNamed(AppRouteNames.teachersPage),
          ),
          const SizedBox(height: 18),
          TeachersFilterRow(
            azSelected: true,
            showGenderFilters: true,
            favoriteSelected: teacher.isFavorite,
            selectedGender: teacher.gender,
            onAZTap: () => context.goNamed(AppRouteNames.teachersPage),
            onRatingTap: () => context.goNamed(AppRouteNames.ratingPage),
            onFavoriteTap: () => _toggleFavorite(context, ref, teacher),
            onFemaleTap: () => context.goNamed(AppRouteNames.wishlistPage),
            onMaleTap: () => context.goNamed(AppRouteNames.wishlistPage),
          ),
          const SizedBox(height: 18),
          _TeacherInfoHeroCard(
            teacher: teacher,
            onScheduleTap: () => context.goNamed(
              AppRouteNames.scheduleTeacherPage,
              pathParameters: {'teacherId': teacher.id},
            ),
            onInfoTap: () => _showTeacherSummary(context, teacher),
            onHelpTap: () => context.pushNamed(AppRouteNames.helpCenterPage),
            onRatingTap: () => context.goNamed(AppRouteNames.ratingPage),
            onFavoriteTap: () => _toggleFavorite(context, ref, teacher),
          ),
          const SizedBox(height: 34),
          _TeacherTextSection(
            title: context.tr('profileSection'),
            text: context.tr(teacher.profile),
          ),
          const SizedBox(height: 28),
          _TeacherTextSection(
            title: context.tr('careerPath'),
            text: context.tr(teacher.careerPath),
          ),
          const SizedBox(height: 28),
          _TeacherTextSection(
            title: context.tr('highlights'),
            text: context.tr(teacher.highlights),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleFavorite(
    BuildContext context,
    WidgetRef ref,
    DoctorProfile teacher,
  ) async {
    if (ref.read(currentUserIdProvider) == null) {
      context.goNamed(AppRouteNames.loginPage);
      return;
    }

    await ref
        .read(profileActionProvider.notifier)
        .toggleFavoriteTeacher(teacher.id, !teacher.isFavorite);
  }

  void _showTeacherSummary(BuildContext context, DoctorProfile teacher) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 22, 24, 34),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                teacher.name,
                style: AppStyles.leagueSpartan20.copyWith(
                  color: AppColors.welcomeBlue,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.tr(teacher.specialty),
                style: AppStyles.leagueSpartan16.copyWith(
                  color: const Color(0xFF252525),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                context.tr(teacher.focus),
                style: AppStyles.leagueSpartan16.copyWith(height: 1.2),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TeacherInfoHeroCard extends StatelessWidget {
  final DoctorProfile teacher;
  final VoidCallback onScheduleTap;
  final VoidCallback onInfoTap;
  final VoidCallback onHelpTap;
  final VoidCallback onRatingTap;
  final VoidCallback onFavoriteTap;

  const _TeacherInfoHeroCard({
    required this.teacher,
    required this.onScheduleTap,
    required this.onInfoTap,
    required this.onHelpTap,
    required this.onRatingTap,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(26, 30, 26, 28),
      decoration: BoxDecoration(
        color: AppColors.signUpButtonBlue,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AdaptiveAvatar(imageSource: teacher.imagePath, radius: 78),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    _ExperienceBadge(years: teacher.experienceYears),
                    const SizedBox(height: 10),
                    _FocusPanel(text: context.tr(teacher.focus)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                Text(
                  teacher.name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.leagueSpartan20.copyWith(
                    color: AppColors.welcomeBlue,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  context.tr(teacher.specialty),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.leagueSpartan16.copyWith(
                    color: const Color(0xFF222222),
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                MetricBadge(
                  icon: Icons.star_rounded,
                  label: _ratingLabel(teacher.rating),
                ),
                MetricBadge(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: '${teacher.reviews}',
                ),
                MetricBadge(
                  icon: Icons.alarm_rounded,
                  label: context.tr(_availabilityLabel(teacher.availability)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              PrimaryPillButton(
                label: context.tr('schedule'),
                onTap: onScheduleTap,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              const Spacer(),
              RoundActionButton(
                icon: Icons.info_outline_rounded,
                onTap: onInfoTap,
              ),
              const SizedBox(width: 8),
              RoundActionButton(
                icon: Icons.question_mark_rounded,
                onTap: onHelpTap,
              ),
              const SizedBox(width: 8),
              RoundActionButton(
                icon: Icons.star_border_rounded,
                onTap: onRatingTap,
              ),
              const SizedBox(width: 8),
              RoundActionButton(
                icon: Icons.favorite_rounded,
                selected: teacher.isFavorite,
                onTap: onFavoriteTap,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _ratingLabel(double rating) {
    if (rating == rating.roundToDouble()) {
      return rating.toStringAsFixed(0);
    }
    return rating.toStringAsFixed(1);
  }

  String _availabilityLabel(String value) {
    return value
        .replaceAll('Mon', 'Mon')
        .replaceAll('Sat', 'Sat')
        .replaceAll('AM', 'AM')
        .replaceAll('PM', 'PM');
  }
}

class _TeacherInfoTopBar extends StatelessWidget {
  final VoidCallback onSearchTap;
  final VoidCallback onFilterTap;

  const _TeacherInfoTopBar({
    required this.onSearchTap,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TopButton(
          icon: Icons.arrow_back_ios_new_rounded,
          plain: true,
          onTap: () {
            if (Navigator.of(context).canPop()) {
              context.pop();
              return;
            }
            context.goNamed(AppRouteNames.teachersPage);
          },
        ),
        const Spacer(),
        Text(
          context.tr('teacherInfo'),
          style: AppStyles.leagueSpartan24.copyWith(
            color: AppColors.welcomeBlue,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        _TopButton(icon: Icons.search_rounded, onTap: onSearchTap),
        const SizedBox(width: 8),
        _TopButton(icon: Icons.tune_rounded, onTap: onFilterTap),
      ],
    );
  }
}

class _TopButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool plain;

  const _TopButton({
    required this.icon,
    required this.onTap,
    this.plain = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: plain
              ? Colors.transparent
              : AppColors.signUpButtonBlue.withValues(alpha: 0.9),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: plain ? 24 : 18, color: AppColors.welcomeBlue),
      ),
    );
  }
}

class _ExperienceBadge extends StatelessWidget {
  final int years;

  const _ExperienceBadge({required this.years});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.welcomeBlue,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.workspace_premium_outlined,
              color: AppColors.welcomeBlue,
              size: 18,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              context.tr('yearsExperience', {'years': years}),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppStyles.leagueSpartan12W600.copyWith(
                color: Colors.white,
                fontSize: 13,
                height: 0.95,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FocusPanel extends StatelessWidget {
  final String text;

  const _FocusPanel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 14, 16),
      decoration: BoxDecoration(
        color: AppColors.welcomeBlue,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: context.tr('focusPrefix'),
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            TextSpan(text: text),
          ],
        ),
        maxLines: 8,
        overflow: TextOverflow.ellipsis,
        style: AppStyles.leagueSpartan16.copyWith(
          color: Colors.white,
          height: 1.02,
        ),
      ),
    );
  }
}

class _TeacherTextSection extends StatelessWidget {
  final String title;
  final String text;

  const _TeacherTextSection({required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: title),
        const SizedBox(height: 8),
        Text(
          text,
          style: AppStyles.leagueSpartan16.copyWith(
            color: const Color(0xFF1F1F1F),
            height: 1.1,
          ),
        ),
      ],
    );
  }
}
