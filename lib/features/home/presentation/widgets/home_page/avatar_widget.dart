import 'package:flutter/material.dart';

import '../../../../../core/constants/app_index.dart';

class AvatarWidget extends StatelessWidget {
  final String? imagePath;

  const AvatarWidget({super.key, this.imagePath});

  @override
  Widget build(BuildContext context) {
    final hasValidImage = imagePath != null && imagePath!.isNotEmpty;
    
    return SizedBox(
      height: 56,
      width: 56,
      child: CircleAvatar(
        backgroundColor: AppColors.signUpButtonBlue,
        backgroundImage: hasValidImage
            ? NetworkImage(imagePath!)
            : AssetImage(AppImages.tryAvatarImage),
      ),
    );
  }
}
