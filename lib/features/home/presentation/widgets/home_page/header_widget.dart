import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medicity_app/core/constants/app_index.dart';
import 'package:medicity_app/core/localization/app_localizations.dart';
import 'package:medicity_app/features/profile/presentation/providers/profile_provider.dart';
import 'avatar_button.dart';
import 'avatar_widget.dart';
import 'header_button.dart';
import 'header_search_field.dart';

class HeaderWidget extends ConsumerWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
    final userName = profileAsync.value?.fullName;
    final userAvatar = profileAsync.value?.avatarPath;

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Column(
        children: [
          Row(
            children: [
              AvatarWidget(imagePath: userAvatar),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr('welcomeBack'),
                      style: AppStyles.leagueSpartan12W300.copyWith(
                        color: AppColors.welcomeBlue,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      userName == null || userName.isEmpty
                          ? context.tr('guest')
                          : userName,
                      style: AppStyles.leagueSpartan16,
                    ),
                  ],
                ),
              ),
              AvatarButton(
                imagePath: AppIcons.notificationIcon,
                onTap: () =>
                    context.pushNamed(AppRouteNames.notificationSettingsPage),
              ),
              SizedBox(width: 8),
              AvatarButton(
                onTap: () => context.pushNamed(AppRouteNames.settingsPage),
              ),
            ],
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              HeaderButton(
                imagePath: AppIcons.doctorsIcon,
                title: context.tr('teachers'),
                onTap: () => context.pushNamed(AppRouteNames.teachersPage),
              ),
              const SizedBox(width: 12),
              HeaderButton(
                imagePath: AppIcons.favouriteIcon,
                title: context.tr('favorite'),
                onTap: () => context.goNamed(AppRouteNames.wishlistPage),
              ),
              const SizedBox(width: 20),
              HeaderSearchField(),
            ],
          ),
        ],
      ),
    );
  }
}
