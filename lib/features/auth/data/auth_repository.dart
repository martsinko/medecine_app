import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:medicity_app/core/constants/app_images.dart';
import 'package:medicity_app/features/profile/presentation/models/profile_models.dart';

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final GoogleSignIn googleSignIn;

  AuthRepository({
    required this.auth,
    required this.firestore,
    required this.googleSignIn,
  });

  Stream<User?> authStateChanges() => auth.authStateChanges();

  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) {
    return auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> signUpWithEmail({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
    required String dateOfBirth,
  }) async {
    final credential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await _createOrMergeUserProfile(
      uid: credential.user!.uid,
      email: email,
      fullName: fullName,
      phoneNumber: phoneNumber,
      dateOfBirth: dateOfBirth,
      photoUrl: credential.user?.photoURL ?? AppImages.tryAvatarImage,
    );

    await credential.user?.updateDisplayName(fullName);
    return credential;
  }

  // Social auth is temporarily disabled until Google/Facebook native
  // configuration is ready.
  // Future<UserCredential> signInWithGoogle() async { ... }
  // Future<UserCredential> signInWithFacebook() async { ... }

  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    final user = auth.currentUser;
    if (user == null) {
      throw Exception('No user logged in');
    }
    if (!_hasProvider(user, 'password')) {
      throw FirebaseAuthException(
        code: 'password-provider-required',
        message: 'This account is not using email and password authentication.',
      );
    }
    if (user.email == null) {
      throw FirebaseAuthException(
        code: 'missing-email',
        message: 'This account does not have an email address.',
      );
    }

    final credential = EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );

    await user.reauthenticateWithCredential(credential);
    await user.updatePassword(newPassword);
  }

  Future<void> deleteAccount({String? password}) async {
    final user = auth.currentUser;
    if (user == null) {
      throw Exception('No user logged in');
    }

    await _reauthenticateForSensitiveAction(user, password: password);
    await _deleteUserData(user.uid);
    await user.delete();
    await googleSignIn.signOut();
  }

  Future<void> signOut() async {
    await Future.wait([auth.signOut(), googleSignIn.signOut()]);
  }

  Future<void> _reauthenticateForSensitiveAction(
    User user, {
    String? password,
  }) async {
    if (_hasProvider(user, 'password')) {
      if (password == null || password.isEmpty) {
        throw FirebaseAuthException(
          code: 'missing-password',
          message: 'Please enter your current password.',
        );
      }
      if (user.email == null) {
        throw FirebaseAuthException(
          code: 'missing-email',
          message: 'This account does not have an email address.',
        );
      }
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);
      return;
    }

    if (_hasProvider(user, 'google.com')) {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw FirebaseAuthException(
          code: 'google_reauth_cancelled',
          message: 'Google reauthentication was cancelled.',
        );
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await user.reauthenticateWithCredential(credential);
      return;
    }

    throw FirebaseAuthException(
      code: 'unsupported-auth-provider',
      message: 'This account provider is not supported for this action.',
    );
  }

  Future<void> _deleteUserData(String uid) async {
    final batch = firestore.batch();
    final userRef = firestore.collection('users').doc(uid);
    final appointments = await firestore
        .collection('appointments')
        .where('userId', isEqualTo: uid)
        .get();

    for (final doc in appointments.docs) {
      batch.delete(doc.reference);
    }
    batch.delete(userRef);
    await batch.commit();
  }

  Future<void> _createOrMergeUserProfile({
    required String uid,
    required String email,
    required String fullName,
    required String phoneNumber,
    required String dateOfBirth,
    required String photoUrl,
  }) async {
    final docRef = firestore.collection('users').doc(uid);
    final snapshot = await docRef.get();
    final existing = snapshot.data() ?? const <String, dynamic>{};
    final data = ProfileData(
      uid: uid,
      fullName: existing['fullName'] as String? ?? fullName,
      phoneNumber: existing['phoneNumber'] as String? ?? phoneNumber,
      email: existing['email'] as String? ?? email,
      dateOfBirth: existing['dateOfBirth'] as String? ?? dateOfBirth,
      avatarPath: existing['photoUrl'] as String? ?? photoUrl,
      favoriteTeacherIds: List<String>.from(
        existing['favoriteTeacherIds'] ?? const <String>[],
      ),
      notificationPreferences: NotificationPreferences.fromMap(
        Map<String, dynamic>.from(
          existing['notificationPreferences'] ?? const <String, dynamic>{},
        ),
      ),
    );

    await docRef.set({
      ...data.toFirestore(),
      'createdAt': existing['createdAt'] ?? Timestamp.now(),
    }, SetOptions(merge: true));
  }

  bool _hasProvider(User user, String providerId) {
    return user.providerData.any(
      (provider) => provider.providerId == providerId,
    );
  }
}
