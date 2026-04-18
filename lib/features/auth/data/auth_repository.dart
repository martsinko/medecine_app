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

  Future<UserCredential> signInWithGoogle() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw FirebaseAuthException(
          code: 'google_sign_in_cancelled',
          message: 'Google sign-in was cancelled.',
        );
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await auth.signInWithCredential(credential);
      final user = userCredential.user!;

      await _createOrMergeUserProfile(
        uid: user.uid,
        email: user.email ?? googleUser.email,
        fullName: user.displayName ?? googleUser.displayName ?? '',
        phoneNumber: user.phoneNumber ?? '',
        dateOfBirth: '',
        photoUrl: user.photoURL ?? '',
      );

return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    final user = auth.currentUser;
    if (user == null) {
      throw Exception('No user logged in');
    }

    final credential = EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );

    await user.reauthenticateWithCredential(credential);
    await user.updatePassword(newPassword);
  }

  Future<void> signOut() async {
    await Future.wait([
      auth.signOut(),
      googleSignIn.signOut(),
    ]);
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
}
