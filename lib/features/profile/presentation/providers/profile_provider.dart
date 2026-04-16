import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/profile_mock.dart';
import '../models/profile_models.dart';

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileData>((
  ref,
) {
  return ProfileNotifier();
});

final notificationPreferencesProvider =
    StateNotifierProvider<
      NotificationPreferencesNotifier,
      NotificationPreferences
    >((ref) {
      return NotificationPreferencesNotifier();
    });

class ProfileNotifier extends StateNotifier<ProfileData> {
  ProfileNotifier() : super(initialProfileData);

  void update(ProfileData data) {
    state = data;
  }
}

class NotificationPreferencesNotifier
    extends StateNotifier<NotificationPreferences> {
  NotificationPreferencesNotifier() : super(initialNotificationPreferences);

  void update(NotificationPreferenceType type, bool value) {
    state = switch (type) {
      NotificationPreferenceType.generalNotification => state.copyWith(
        generalNotification: value,
      ),
      NotificationPreferenceType.sound => state.copyWith(sound: value),
      NotificationPreferenceType.soundCall => state.copyWith(soundCall: value),
      NotificationPreferenceType.vibrate => state.copyWith(vibrate: value),
      NotificationPreferenceType.specialOffers => state.copyWith(
        specialOffers: value,
      ),
      NotificationPreferenceType.payments => state.copyWith(payments: value),
      NotificationPreferenceType.promoAndDiscount => state.copyWith(
        promoAndDiscount: value,
      ),
      NotificationPreferenceType.cashback => state.copyWith(cashback: value),
    };
  }
}
