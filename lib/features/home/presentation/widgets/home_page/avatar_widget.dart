import 'package:flutter/material.dart';
import 'package:medicity_app/shared/widgets/adaptive_avatar.dart';

import '../../../../../core/constants/app_index.dart';

class AvatarWidget extends StatelessWidget {
  final String? imagePath;

  const AvatarWidget({super.key, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: 56,
      child: AdaptiveAvatar(
        imageSource: imagePath?.isNotEmpty == true
            ? imagePath
            : AppImages.tryAvatarImage,
        radius: 28,
      ),
    );
  }
}
