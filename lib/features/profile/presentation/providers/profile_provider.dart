import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicity_app/core/firebase/firebase_providers.dart';
import 'package:medicity_app/features/profile/data/profile_avatar_repository.dart';
import 'package:medicity_app/features/profile/data/profile_repository.dart';

import '../models/profile_models.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(firestore: ref.watch(firestoreProvider));
});

final profileAvatarRepositoryProvider = Provider<ProfileAvatarRepository>((
  ref,
) {
  return ProfileAvatarRepository();
});

final currentUserIdProvider = Provider<String?>((ref) {
  return ref.watch(authStateChangesProvider).value?.uid;
});

final profileProvider = StreamProvider<ProfileData?>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) {
    return Stream.value(null);
  }

  return ref.watch(profileRepositoryProvider).watchUser(userId);
});

final profileActionProvider =
    StateNotifierProvider<ProfileActionNotifier, AsyncValue<void>>((ref) {
      return ProfileActionNotifier(ref);
    });

class ProfileActionNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  ProfileActionNotifier(this._ref) : super(const AsyncData(null));

  Future<void> update(ProfileData data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _ref.watch(profileRepositoryProvider).updateProfile(data),
    );
  }

  Future<bool> pickAndUpdateAvatar(ProfileData currentProfile) async {
    final uid = _ref.read(currentUserIdProvider) ?? currentProfile.uid;
    if (uid.isEmpty) {
      state = AsyncError(
        StateError('User is not logged in.'),
        StackTrace.current,
      );
      return false;
    }

    state = const AsyncLoading();
    var updated = false;
    state = await AsyncValue.guard(() async {
      final avatarPath = await _ref
          .read(profileAvatarRepositoryProvider)
          .pickAndPersistAvatar(uid);
      if (avatarPath == null) {
        return;
      }

      await _ref
          .read(profileRepositoryProvider)
          .updateProfile(
            currentProfile.copyWith(uid: uid, avatarPath: avatarPath),
          );
      updated = true;
    });
    return updated && !state.hasError;
  }

  Future<void> updateNotificationPreferences(
    NotificationPreferences preferences,
  ) async {
    final uid = _ref.read(currentUserIdProvider);
    if (uid == null) {
      state = AsyncError(
        StateError('User is not logged in.'),
        StackTrace.current,
      );
      return;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _ref
          .watch(profileRepositoryProvider)
          .updateNotificationPreferences(uid, preferences),
    );
  }

  Future<void> toggleFavoriteTeacher(String teacherId, bool isFavorite) async {
    final uid = _ref.read(currentUserIdProvider);
    if (uid == null) {
      state = AsyncError(
        StateError('User is not logged in.'),
        StackTrace.current,
      );
      return;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _ref
          .watch(profileRepositoryProvider)
          .toggleFavoriteTeacher(
            uid: uid,
            teacherId: teacherId,
            isFavorite: isFavorite,
          ),
    );
  }
}
