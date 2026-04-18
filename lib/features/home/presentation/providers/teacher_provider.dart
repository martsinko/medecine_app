import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicity_app/core/firebase/firebase_providers.dart';
import 'package:medicity_app/features/home/data/teacher_repository.dart';
import 'package:medicity_app/features/home/presentation/models/doctor_profile.dart';
import 'package:medicity_app/features/profile/presentation/providers/profile_provider.dart';

final teacherRepositoryProvider = Provider<TeacherRepository>((ref) {
  return TeacherRepository(firestore: ref.watch(firestoreProvider));
});

final rawTeachersProvider = StreamProvider<List<DoctorProfile>>((ref) {
  return ref.watch(teacherRepositoryProvider).watchTeachers();
});

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
