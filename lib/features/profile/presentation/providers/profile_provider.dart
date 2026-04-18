import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicity_app/core/firebase/firebase_providers.dart';
import 'package:medicity_app/features/profile/data/profile_repository.dart';

import '../models/profile_models.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(firestore: ref.watch(firestoreProvider));
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
