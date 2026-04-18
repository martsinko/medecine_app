import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medicity_app/features/profile/presentation/models/profile_models.dart';

class ProfileRepository {
  final FirebaseFirestore firestore;

  ProfileRepository({required this.firestore});

  Stream<ProfileData?> watchUser(String uid) {
    return firestore.collection('users').doc(uid).snapshots().map((snapshot) {
      final data = snapshot.data();
      if (data == null) {
        return null;
      }
      return ProfileData.fromFirestore(snapshot.id, data);
    });
  }

  Future<void> updateProfile(ProfileData profile) {
    return firestore.collection('users').doc(profile.uid).set(
      profile.toFirestore(),
      SetOptions(merge: true),
    );
  }

  Future<void> updateNotificationPreferences(
    String uid,
    NotificationPreferences preferences,
  ) {
    return firestore.collection('users').doc(uid).set({
      'notificationPreferences': preferences.toMap(),
      'updatedAt': Timestamp.now(),
    }, SetOptions(merge: true));
  }

  Future<void> toggleFavoriteTeacher({
    required String uid,
    required String teacherId,
    required bool isFavorite,
  }) {
    return firestore.collection('users').doc(uid).set({
      'favoriteTeacherIds': isFavorite
          ? FieldValue.arrayUnion([teacherId])
          : FieldValue.arrayRemove([teacherId]),
      'updatedAt': Timestamp.now(),
    }, SetOptions(merge: true));
  }
}
