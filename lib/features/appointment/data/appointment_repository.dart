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

  Future<bool> hasConflictBooking({
    required String userId,
    required String doctorId,
    required String dateLabel,
    required String timeLabel,
  }) async {
    final snapshot = await firestore
        .collection('appointments')
        .where('userId', isEqualTo: userId)
        .where('doctorId', isEqualTo: doctorId)
        .where('dateLabel', isEqualTo: dateLabel)
        .where('status', isEqualTo: AppointmentStatus.upcoming.name)
        .get();
    for (final doc in snapshot.docs) {
      final appointment = AppointmentEntry.fromFirestore(doc.id, doc.data());
      if (appointment.timeLabel.contains(timeLabel.split(',').last.trim())) {
        return true;
      }
    }
    return false;
  }

  Future<List<String>> getUnavailableTimeSlots({
    required String doctorId,
    required String dateLabel,
  }) async {
    final snapshot = await firestore
        .collection('appointments')
        .where('doctorId', isEqualTo: doctorId)
        .where('dateLabel', isEqualTo: dateLabel)
        .where('status', isEqualTo: AppointmentStatus.upcoming.name)
        .get();
    final unavailableSlots = <String>[];
    for (final doc in snapshot.docs) {
      final appointment = AppointmentEntry.fromFirestore(doc.id, doc.data());
      final timePart = appointment.timeLabel.split(',').last.trim();
      if (!unavailableSlots.contains(timePart)) {
        unavailableSlots.add(timePart);
      }
    }
    return unavailableSlots;
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
