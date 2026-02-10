import 'package:flutter/material.dart';

import '../../../../core/constants/app_index.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: 56,
      child: CircleAvatar(
        backgroundImage: AssetImage(AppImages.tryAvatarImage),
      ),
    );
  }
}
