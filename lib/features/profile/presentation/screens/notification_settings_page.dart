import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicity_app/core/localization/app_localizations.dart';

import '../data/profile_mock.dart';
import '../models/profile_models.dart';
import '../providers/profile_provider.dart';
import '../widgets/profile_components.dart';

class NotificationSettingsPage extends ConsumerWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences =
        ref.watch(profileProvider).value?.notificationPreferences ??
        initialNotificationPreferences;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
          child: ListView(
            children: [
              ProfileTopBar(title: context.tr('notificationSetting')),
              const SizedBox(height: 34),
              NotificationSwitchTile(
                title: context.tr('generalNotification'),
                value: preferences.generalNotification,
                onChanged: (value) => _update(
                  ref,
                  preferences,
                  NotificationPreferenceType.generalNotification,
                  value,
                ),
              ),
              NotificationSwitchTile(
                title: context.tr('sound'),
                value: preferences.sound,
                onChanged: (value) => _update(
                  ref,
                  preferences,
                  NotificationPreferenceType.sound,
                  value,
                ),
              ),
              NotificationSwitchTile(
                title: context.tr('soundCall'),
                value: preferences.soundCall,
                onChanged: (value) => _update(
                  ref,
                  preferences,
                  NotificationPreferenceType.soundCall,
                  value,
                ),
              ),
              NotificationSwitchTile(
                title: context.tr('vibrate'),
                value: preferences.vibrate,
                onChanged: (value) => _update(
                  ref,
                  preferences,
                  NotificationPreferenceType.vibrate,
                  value,
                ),
              ),
              NotificationSwitchTile(
                title: context.tr('specialOffers'),
                value: preferences.specialOffers,
                onChanged: (value) => _update(
                  ref,
                  preferences,
                  NotificationPreferenceType.specialOffers,
                  value,
                ),
              ),
              NotificationSwitchTile(
                title: context.tr('promoAndDiscount'),
                value: preferences.promoAndDiscount,
                onChanged: (value) => _update(
                  ref,
                  preferences,
                  NotificationPreferenceType.promoAndDiscount,
                  value,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _update(
    WidgetRef ref,
    NotificationPreferences preferences,
    NotificationPreferenceType type,
    bool value,
  ) {
    final updated = switch (type) {
      NotificationPreferenceType.generalNotification => preferences.copyWith(
        generalNotification: value,
      ),
      NotificationPreferenceType.sound => preferences.copyWith(sound: value),
      NotificationPreferenceType.soundCall => preferences.copyWith(
        soundCall: value,
      ),
      NotificationPreferenceType.vibrate => preferences.copyWith(
        vibrate: value,
      ),
      NotificationPreferenceType.specialOffers => preferences.copyWith(
        specialOffers: value,
      ),
      NotificationPreferenceType.promoAndDiscount => preferences.copyWith(
        promoAndDiscount: value,
      ),
    };

    ref
        .read(profileActionProvider.notifier)
        .updateNotificationPreferences(updated);
  }
}
