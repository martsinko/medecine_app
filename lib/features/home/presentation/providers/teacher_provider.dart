import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicity_app/core/firebase/firebase_providers.dart';
import 'package:medicity_app/features/home/data/teacher_repository.dart';
import 'package:medicity_app/features/home/presentation/data/doctors_mock.dart';
import 'package:medicity_app/features/home/presentation/models/doctor_profile.dart';
import 'package:medicity_app/features/profile/presentation/providers/profile_provider.dart';

final teacherRepositoryProvider = Provider<TeacherRepository>((ref) {
  return TeacherRepository(firestore: ref.watch(firestoreProvider));
});

final rawTeachersProvider = StreamProvider<List<DoctorProfile>>((ref) {
  final stream = ref.watch(teacherRepositoryProvider).watchTeachers();
  return stream.map((teachers) {
    if (teachers.isEmpty) {
      return _addMockScheduleData(doctorsMock);
    }
    return teachers;
  });
});

List<DoctorProfile> _addMockScheduleData(List<DoctorProfile> teachers) {
  final now = DateTime.now();
  final dates = [
    for (int i = 0; i < 14; i++)
      now.add(Duration(days: i + 1)).toString().split(' ').first,
  ];
  return [
    for (final teacher in teachers)
      teacher.copyWith(
        schedule: TeacherSchedule(
          availableDates: dates,
          timeSlots: [
            '09:00', '09:30', '10:00', '10:30', '11:00', '11:30',
            '13:00', '13:30', '14:00', '14:30', '15:00', '15:30',
          ],
          appointmentDuration: 30,
          bookingEnabled: true,
        ),
      ),
  ];
}

final teachersProvider = Provider<AsyncValue<List<DoctorProfile>>>((ref) {
  final teachersAsync = ref.watch(rawTeachersProvider);
  final profileAsync = ref.watch(profileProvider);

  return teachersAsync.whenData((teachers) {
    final favoriteIds = profileAsync.value?.favoriteTeacherIds ?? const <String>[];
    return [
      for (final teacher in teachers)
        teacher.copyWith(isFavorite: favoriteIds.contains(teacher.id)),
    ];
  });
});

final teacherByIdProvider =
    Provider.family<AsyncValue<DoctorProfile?>, String>((ref, teacherId) {
      final teachersAsync = ref.watch(teachersProvider);
      return teachersAsync.whenData((teachers) {
        for (final teacher in teachers) {
          if (teacher.id == teacherId) {
            return teacher;
          }
        }
        return null;
      });
    });
