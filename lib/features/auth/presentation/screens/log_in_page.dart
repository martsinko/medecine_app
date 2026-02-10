import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medicity_app/shared/widgets/app_button.dart';
import '../../../../core/constants/app_index.dart';
import '../../../../shared/widgets/custom_appbar.dart';
import '../../../../shared/widgets/custom_textfield.dart';
import '../widgets/sign_up_buttons.dart';

class LogInPage extends StatelessWidget {
  final bool isFromWelcome;
  const LogInPage({super.key, this.isFromWelcome = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar(
        title: 'Log In',
        onBackPressed: isFromWelcome
            ? () => context.goNamed(AppRouteNames.welcomeScreen)
            : () => context.pop(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 34),
              Text(
                AppString.loginTitle,
                style: AppStyles.leagueSpartan24.copyWith(
                  color: AppColors.welcomeBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 12),
              Text(
                AppString.welcomeLatinText,
                style: AppStyles.leagueSpartan12W300,
              ),
              SizedBox(height: 48),
              CustomTextField(
                labelText: AppString.emailField,
                hintText: 'example@example.com',
              ),
              SizedBox(height: 20),
              CustomTextField(
                labelText: AppString.passwordTitle,
                hintText: AppString.hintPassword,
                isPassword: true,
              ),
              SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => context.pushNamed(AppRouteNames.setPassword),
                  child: Text(
                    AppString.forgetPassword,
                    style: AppStyles.leagueSpartan12W600.copyWith(
                      color: AppColors.welcomeBlue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 42),
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 65),
                child: AppButton(
                  title: AppString.logIn,
                  onPressed: () => context.pushNamed(AppRouteNames.homePage),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: Text(
                  AppString.orSignUpText,
                  textAlign: TextAlign.center,
                  style: AppStyles.leagueSpartan12W300,
                ),
              ),
              SizedBox(height: 12),
              SingUpButtons(),
              SizedBox(height: 38),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppString.dontHaveAccount,
                    style: AppStyles.leagueSpartan12W300,
                  ),
                  SizedBox(width: 4),
                  GestureDetector(
                    onTap: () => context.pushNamed(AppRouteNames.signUpPage),
                    child: Text(
                      AppString.signUp,
                      style: AppStyles.leagueSpartan12W600.copyWith(
                        color: AppColors.welcomeBlue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
