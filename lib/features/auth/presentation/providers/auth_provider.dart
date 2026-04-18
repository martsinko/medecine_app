import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicity_app/core/firebase/firebase_providers.dart';
import 'package:medicity_app/features/auth/data/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    auth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firestoreProvider),
    googleSignIn: ref.watch(googleSignInProvider),
  );
});

final authActionProvider =
    StateNotifierProvider<AuthActionNotifier, AsyncValue<void>>((ref) {
      return AuthActionNotifier(ref.watch(authRepositoryProvider));
    });

class AuthActionNotifier extends StateNotifier<AsyncValue<void>> {
  final AuthRepository _repository;

  AuthActionNotifier(this._repository) : super(const AsyncData(null));

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repository.signInWithEmail(email: email, password: password),
    );
  }

  Future<void> signUpWithEmail({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
    required String dateOfBirth,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repository.signUpWithEmail(
        fullName: fullName,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
        dateOfBirth: dateOfBirth,
      ),
    );
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_repository.signInWithGoogle);
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_repository.signOut);
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repository.changePassword(currentPassword, newPassword),
    );
  }
}
