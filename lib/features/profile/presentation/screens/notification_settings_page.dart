import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/profile_models.dart';
import '../providers/profile_provider.dart';
import '../widgets/profile_components.dart';

class NotificationSettingsPage extends ConsumerWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(notificationPreferencesProvider);
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
                onChanged: (value) => ref
                    .read(notificationPreferencesProvider.notifier)
                    .update(
                      NotificationPreferenceType.generalNotification,
                      value,
                    ),
              ),
              NotificationSwitchTile(
                title: 'Sound',
                value: preferences.sound,
                onChanged: (value) => ref
                    .read(notificationPreferencesProvider.notifier)
                    .update(NotificationPreferenceType.sound, value),
              ),
              NotificationSwitchTile(
                title: 'Sound Call',
                value: preferences.soundCall,
                onChanged: (value) => ref
                    .read(notificationPreferencesProvider.notifier)
                    .update(NotificationPreferenceType.soundCall, value),
              ),
              NotificationSwitchTile(
                title: 'Vibrate',
                value: preferences.vibrate,
                onChanged: (value) => ref
                    .read(notificationPreferencesProvider.notifier)
                    .update(NotificationPreferenceType.vibrate, value),
              ),
              NotificationSwitchTile(
                title: 'Special Offers',
                value: preferences.specialOffers,
                onChanged: (value) => ref
                    .read(notificationPreferencesProvider.notifier)
                    .update(NotificationPreferenceType.specialOffers, value),
              ),
              NotificationSwitchTile(
                title: 'Payments',
                value: preferences.payments,
                onChanged: (value) => ref
                    .read(notificationPreferencesProvider.notifier)
                    .update(NotificationPreferenceType.payments, value),
              ),
              NotificationSwitchTile(
                title: 'Promo And Discount',
                value: preferences.promoAndDiscount,
                onChanged: (value) => ref
                    .read(notificationPreferencesProvider.notifier)
                    .update(NotificationPreferenceType.promoAndDiscount, value),
              ),
              NotificationSwitchTile(
                title: 'Cashback',
                value: preferences.cashback,
                onChanged: (value) => ref
                    .read(notificationPreferencesProvider.notifier)
                    .update(NotificationPreferenceType.cashback, value),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
