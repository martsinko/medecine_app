import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_index.dart';
import '../../../../shared/widgets/app_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 110),
              Image.asset(
                AppImages.backgroundWelcomeImage2,
                width: 130,
                height: 130,
              ),
              SizedBox(height: 14),
              Text(
                AppString.welcomeTitle,
                textAlign: TextAlign.center,
                style: AppStyles.leagueSpartan48.copyWith(
                  color: AppColors.welcomeBlue,
                ),
              ),
              SizedBox(height: 17),
              Text(
                AppString.welcomeSubtitle,
                style: AppStyles.leagueSpartan12W600.copyWith(
                  color: AppColors.welcomeBlue,
                ),
              ),
              SizedBox(height: 90),
              Text(
                AppString.welcomeLatinText,
                textAlign: TextAlign.center,
                style: AppStyles.leagueSpartan12W300,
              ),
              SizedBox(height: 32),
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    AppButton(
                      title: AppString.logIn,
                      onPressed: () => context.pushNamed(
                        AppRouteNames.loginPage,
                        extra: true,
                      ),
                      backgroundButtonColor: AppColors.welcomeBlue,
                    ),
                    SizedBox(height: 12),
                    AppButton(
                      title: AppString.signUp,
                      onPressed: () => context.pushNamed(
                        AppRouteNames.signUpPage,
                        extra: true,
                      ),
                      backgroundButtonColor: AppColors.signUpButtonBlue,
                      textColor: AppColors.welcomeBlue,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
