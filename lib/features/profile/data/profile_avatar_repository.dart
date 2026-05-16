import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ProfileAvatarRepository {
  final ImagePicker _picker;

  ProfileAvatarRepository({ImagePicker? picker})
    : _picker = picker ?? ImagePicker();

  Future<String?> pickAndPersistAvatar(String userId) async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 900,
      imageQuality: 85,
    );
    if (pickedFile == null) {
      return null;
    }

    final appDirectory = await getApplicationDocumentsDirectory();
    final avatarDirectory = Directory('${appDirectory.path}/profile_avatars');
    if (!await avatarDirectory.exists()) {
      await avatarDirectory.create(recursive: true);
    }

    final extension = _fileExtension(pickedFile.path);
    final fileName =
        'student_avatar_${userId}_${DateTime.now().millisecondsSinceEpoch}$extension';
    final savedFile = File('${avatarDirectory.path}/$fileName');
    await File(pickedFile.path).copy(savedFile.path);

    return savedFile.path;
  }

  String _fileExtension(String path) {
    final index = path.lastIndexOf('.');
    if (index == -1 || index == path.length - 1) {
      return '.jpg';
    }
    return path.substring(index);
  }
}
