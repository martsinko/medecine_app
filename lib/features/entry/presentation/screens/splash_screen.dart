import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medicity_app/core/constants/app_index.dart';
import 'package:medicity_app/core/firebase/firebase_providers.dart';
import 'welcome_screen.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authUser = ref.watch(authStateChangesProvider).value;

    return AnimatedSplashScreen(
      splash: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppImages.backgroundWelcomeImage,
                width: 130,
                height: 130,
              ),
              const SizedBox(height: 20),
              Text(
                AppString.splashTitle,
                textAlign: TextAlign.center,
                style: AppStyles.leagueSpartan48,
              ),
              const SizedBox(height: 17),
              Text(
                AppString.splashSubtitle,
                style: AppStyles.leagueSpartan12W600,
              ),
            ],
          ),
        ),
      ),
      nextScreen: authUser != null
          ? const _RedirectToHome()
          : const WelcomeScreen(),
      splashIconSize: 400,
      duration: 2000,
      backgroundColor: AppColors.welcomeBlue,
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: .fade,
    );
  }
}

class _RedirectToHome extends ConsumerWidget {
  const _RedirectToHome();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.goNamed(AppRouteNames.homePage);
    });
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}