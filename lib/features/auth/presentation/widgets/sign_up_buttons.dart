import 'package:flutter/material.dart';

import '../../../../core/constants/app_index.dart';
import 'custom_auth_button.dart';

class SingUpButtons extends StatelessWidget {
  const SingUpButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 10,
      children: [
        CustomAuthButton(onTap: () {}, assetPath: AppIcons.googleIcon),
        CustomAuthButton(onTap: () {}, assetPath: AppIcons.facebookIcon),
        CustomAuthButton(onTap: () {}, assetPath: AppIcons.touchIcon),
      ],
    );
  }
}
