import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medicity_app/features/appointment/presentation/models/appointment_models.dart';

class AppointmentRepository {
  final FirebaseFirestore firestore;

  AppointmentRepository({required this.firestore});

  Stream<List<AppointmentEntry>> watchAppointments(String userId) {
    return firestore
        .collection('appointments')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => AppointmentEntry.fromFirestore(doc.id, doc.data()))
              .toList();
        });
  }

  Future<void> setAppointment(AppointmentEntry appointment, String userId) {
    return firestore.collection('appointments').doc(appointment.id).set({
      ...appointment.toFirestore(),
      'userId': userId,
    }, SetOptions(merge: true));
  }

  Future<void> updateAppointment(
    String appointmentId,
    Map<String, dynamic> data,
  ) {
    return firestore.collection('appointments').doc(appointmentId).set({
      ...data,
      'updatedAt': Timestamp.now(),
    }, SetOptions(merge: true));
  }
}
