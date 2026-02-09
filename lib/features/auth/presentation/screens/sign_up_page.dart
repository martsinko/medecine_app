import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medicity_app/shared/widgets/custom_appbar.dart';
import 'package:medicity_app/shared/widgets/custom_textfield.dart';
import '../../../../core/constants/app_index.dart';
import '../../../../shared/widgets/app_button.dart';
import '../widgets/sign_up_buttons.dart';

class SignUpPage extends StatelessWidget {
  final bool isFromWelcome;
  const SignUpPage({super.key, this.isFromWelcome = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar(
        title: AppString.newAccount,
        onBackPressed: isFromWelcome
            ? () => context.goNamed(AppRouteNames.welcomeScreen)
            : () => context.pop(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              spacing: 20,
              children: [
                SizedBox(height: 8),
                CustomTextField(
                  hintText: 'Enter your full name',
                  labelText: AppString.fullNameText,
                ),
                CustomTextField(
                  hintText: AppString.hintPassword,
                  labelText: AppString.passwordTitle,
                  isPassword: true,
                ),
                CustomTextField(
                  hintText: 'example@example.com',
                  labelText: AppString.emailText,
                ),
                CustomTextField(
                  hintText: 'Enter your phone number',
                  keyboardType: TextInputType.phone,
                  isPhone: true,
                  labelText: AppString.phonemeNumberField,
                ),
                CustomTextField(
                  hintText: 'DD/MM/YYYY',
                  isDate: true,
                  labelText: AppString.dateOfBitrh,
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: AppStyles.leagueSpartan12W300,
                    children: [
                      const TextSpan(text: AppString.termsUseText1),
                      TextSpan(
                        text: AppString.termsUseText,
                        style: AppStyles.leagueSpartan12W300.copyWith(
                          color: AppColors.welcomeBlue,
                          fontWeight: FontWeight.w600,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                      const TextSpan(text: ' and '),
                      TextSpan(
                        text: AppString.privacyPolicyText,
                        style: AppStyles.leagueSpartan12W300.copyWith(
                          color: AppColors.welcomeBlue,
                          fontWeight: FontWeight.w600,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                      const TextSpan(text: '.'),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(horizontal: 70),
                  child: AppButton(title: AppString.signUp, onPressed: () {}),
                ),
                Center(
                  child: Text(
                    AppString.orSignUpText,
                    textAlign: TextAlign.center,
                    style: AppStyles.leagueSpartan12W300,
                  ),
                ),
                SingUpButtons(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppString.alreadyHaveAccount,
                      style: AppStyles.leagueSpartan12W300,
                    ),
                    SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => context.pushNamed(AppRouteNames.loginPage),
                      child: Text(
                        AppString.logIn,
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
      ),
    );
  }
}
