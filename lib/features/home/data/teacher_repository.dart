import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medicity_app/features/home/presentation/models/doctor_profile.dart';

class TeacherRepository {
  final FirebaseFirestore firestore;

  TeacherRepository({required this.firestore});

  Stream<List<DoctorProfile>> watchTeachers() {
    return firestore.collection('teachers').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => DoctorProfile.fromFirestore(doc.id, doc.data()))
          .toList();
    });
  }
}
