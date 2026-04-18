import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_index.dart';
import '../providers/auth_provider.dart';
import 'custom_auth_button.dart';

class SingUpButtons extends ConsumerWidget {
  const SingUpButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 10,
      children: [
        CustomAuthButton(
          onTap: () async {
            await ref.read(authActionProvider.notifier).signInWithGoogle();
            final state = ref.read(authActionProvider);
            if (state.hasError && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error.toString())),
              );
              return;
            }
            if (context.mounted) {
              context.goNamed(AppRouteNames.homePage);
            }
          },
          assetPath: AppIcons.googleIcon,
        ),
        CustomAuthButton(onTap: () {}, assetPath: AppIcons.facebookIcon),
        CustomAuthButton(onTap: () {}, assetPath: AppIcons.touchIcon),
      ],
    );
  }
}
