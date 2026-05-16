import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medicity_app/core/constants/app_index.dart';
import 'package:medicity_app/core/localization/app_localizations.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../data/profile_mock.dart';
import '../models/profile_models.dart';
import '../providers/profile_provider.dart';
import '../widgets/profile_components.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(profileProvider)
        .when(
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
                        title: context.tr('myProfile'),
                        onBackTap: () =>
                            context.goNamed(AppRouteNames.homePage),
                      ),
                      const SizedBox(height: 18),
                      Center(
                        child: ProfileAvatar(
                          imagePath: currentProfile.avatarPath,
                          onActionTap: () =>
                              _pickStudentPhoto(context, ref, currentProfile),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        currentProfile.fullName.isEmpty
                            ? context.tr('guest')
                            : currentProfile.fullName,
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
                          title: context.tr(item.title),
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
          error: (error, stackTrace) => Scaffold(
            body: SafeArea(
              child: Center(child: Text(context.tr('failedLoadProfile'))),
            ),
          ),
        );
  }

  void _handleMenuTap(BuildContext context, WidgetRef ref, String title) {
    switch (title) {
      case 'profile':
        context.pushNamed(AppRouteNames.editProfilePage);
      case 'favorite':
        context.goNamed(AppRouteNames.wishlistPage);
      case 'privacyPolicy':
        context.pushNamed(AppRouteNames.privacyPolicyPage);
      case 'settings':
        context.pushNamed(AppRouteNames.settingsPage);
      case 'help':
        context.pushNamed(AppRouteNames.helpCenterPage);
      case 'logout':
        _showLogoutSheet(context, ref);
    }
  }

  Future<void> _pickStudentPhoto(
    BuildContext context,
    WidgetRef ref,
    ProfileData currentProfile,
  ) async {
    final updated = await ref
        .read(profileActionProvider.notifier)
        .pickAndUpdateAvatar(currentProfile);
    final state = ref.read(profileActionProvider);
    if (!context.mounted) {
      return;
    }

    if (state.hasError) {
      state.whenOrNull(
        error: (error, _) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(context.trError(error))));
        },
      );
      return;
    }

    if (updated) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.tr('profilePhotoUpdated'))),
      );
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
                context.tr('logout'),
                style: AppStyles.leagueSpartan24.copyWith(
                  color: AppColors.welcomeBlue,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                context.tr('logoutQuestion'),
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
                      label: context.tr('cancel'),
                      selected: false,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _LogoutActionButton(
                      label: context.tr('yesLogout'),
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
