import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
              const ProfileTopBar(title: 'Notification Setting'),
              const SizedBox(height: 34),
              NotificationSwitchTile(
                title: 'General Notification',
                value: preferences.generalNotification,
                onChanged: (value) => _update(
                  ref,
                  preferences,
                  NotificationPreferenceType.generalNotification,
                  value,
                ),
              ),
              NotificationSwitchTile(
                title: 'Sound',
                value: preferences.sound,
                onChanged: (value) => _update(
                  ref,
                  preferences,
                  NotificationPreferenceType.sound,
                  value,
                ),
              ),
              NotificationSwitchTile(
                title: 'Sound Call',
                value: preferences.soundCall,
                onChanged: (value) => _update(
                  ref,
                  preferences,
                  NotificationPreferenceType.soundCall,
                  value,
                ),
              ),
              NotificationSwitchTile(
                title: 'Vibrate',
                value: preferences.vibrate,
                onChanged: (value) => _update(
                  ref,
                  preferences,
                  NotificationPreferenceType.vibrate,
                  value,
                ),
              ),
              NotificationSwitchTile(
                title: 'Special Offers',
                value: preferences.specialOffers,
                onChanged: (value) => _update(
                  ref,
                  preferences,
                  NotificationPreferenceType.specialOffers,
                  value,
                ),
              ),
              NotificationSwitchTile(
                title: 'Payments',
                value: preferences.payments,
                onChanged: (value) => _update(
                  ref,
                  preferences,
                  NotificationPreferenceType.payments,
                  value,
                ),
              ),
              NotificationSwitchTile(
                title: 'Promo And Discount',
                value: preferences.promoAndDiscount,
                onChanged: (value) => _update(
                  ref,
                  preferences,
                  NotificationPreferenceType.promoAndDiscount,
                  value,
                ),
              ),
              NotificationSwitchTile(
                title: 'Cashback',
                value: preferences.cashback,
                onChanged: (value) => _update(
                  ref,
                  preferences,
                  NotificationPreferenceType.cashback,
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
      NotificationPreferenceType.generalNotification =>
        preferences.copyWith(generalNotification: value),
      NotificationPreferenceType.sound => preferences.copyWith(sound: value),
      NotificationPreferenceType.soundCall =>
        preferences.copyWith(soundCall: value),
      NotificationPreferenceType.vibrate =>
        preferences.copyWith(vibrate: value),
      NotificationPreferenceType.specialOffers =>
        preferences.copyWith(specialOffers: value),
      NotificationPreferenceType.payments =>
        preferences.copyWith(payments: value),
      NotificationPreferenceType.promoAndDiscount =>
        preferences.copyWith(promoAndDiscount: value),
      NotificationPreferenceType.cashback =>
        preferences.copyWith(cashback: value),
    };

    ref.read(profileActionProvider.notifier).updateNotificationPreferences(updated);
  }
}
