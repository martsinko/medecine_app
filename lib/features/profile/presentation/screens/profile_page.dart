import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medicity_app/core/constants/app_index.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../data/profile_mock.dart';
import '../providers/profile_provider.dart';
import '../widgets/profile_components.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(profileProvider).when(
      data: (profile) {
        final currentProfile = profile ?? initialProfileData;
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
              child: ListView(
                padding: const EdgeInsets.only(bottom: 120),
                children: [
                  ProfileTopBar(
                    title: 'My Profile',
                    onBackTap: () => context.goNamed(AppRouteNames.homePage),
                  ),
                  const SizedBox(height: 18),
                  Center(
                    child: ProfileAvatar(
                      imagePath: currentProfile.avatarPath,
                      onActionTap: () =>
                          context.pushNamed(AppRouteNames.editProfilePage),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    currentProfile.fullName,
                    textAlign: TextAlign.center,
                    style: AppStyles.leagueSpartan24.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 28),
                  for (final item in profileMenuEntries)
                    ProfileMenuTile(
                      icon: item.icon,
                      title: item.title,
                      onTap: () => _handleMenuTap(context, ref, item.title),
                    ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: SafeArea(child: Center(child: CircularProgressIndicator())),
      ),
      error: (error, stackTrace) => const Scaffold(
        body: SafeArea(child: Center(child: Text('Failed to load profile.'))),
      ),
    );
  }

  void _handleMenuTap(BuildContext context, WidgetRef ref, String title) {
    switch (title) {
      case 'Profile':
        context.pushNamed(AppRouteNames.editProfilePage);
      case 'Favorite':
        context.goNamed(AppRouteNames.wishlistPage);
      case 'Privacy Policy':
        context.pushNamed(AppRouteNames.privacyPolicyPage);
      case 'Settings':
        context.pushNamed(AppRouteNames.settingsPage);
      case 'Help':
        context.pushNamed(AppRouteNames.helpCenterPage);
      case 'Logout':
        _showLogoutSheet(context, ref);
    }
  }

  void _showLogoutSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.welcomeBlue.withValues(alpha: 0.45),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 28),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Logout',
                style: AppStyles.leagueSpartan24.copyWith(
                  color: AppColors.welcomeBlue,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'are you sure you want to log out?',
                style: AppStyles.leagueSpartan16.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _LogoutActionButton(
                      label: 'Cancel',
                      selected: false,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _LogoutActionButton(
                      label: 'Yes, Logout',
                      selected: true,
                      onTap: () async {
                        Navigator.of(context).pop();
                        await ref.read(authActionProvider.notifier).signOut();
                        if (context.mounted) {
                          context.goNamed(AppRouteNames.welcomeScreen);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LogoutActionButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LogoutActionButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: selected ? AppColors.welcomeBlue : AppColors.signUpButtonBlue,
          borderRadius: BorderRadius.circular(999),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppStyles.leagueSpartan16.copyWith(
            color: selected ? Colors.white : AppColors.welcomeBlue,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
