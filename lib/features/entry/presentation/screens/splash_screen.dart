import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_index.dart';
import 'welcome_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              SizedBox(height: 20),
              Text(
                AppString.splashTitle,
                textAlign: TextAlign.center,
                style: AppStyles.leagueSpartan48,
              ),
              SizedBox(height: 17),
              Text(
                AppString.splashSubtitle,
                style: AppStyles.leagueSpartan12W600,
              ),
            ],
          ),
        ),
      ),
      nextScreen: const WelcomeScreen(),
      splashIconSize: 400,
      duration: 4000,
      backgroundColor: AppColors.welcomeBlue,
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: .fade,
    );
  }
}
