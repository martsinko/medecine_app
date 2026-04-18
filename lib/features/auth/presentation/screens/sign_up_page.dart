import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medicity_app/shared/widgets/custom_appbar.dart';
import 'package:medicity_app/shared/widgets/custom_textfield.dart';

import '../../../../core/constants/app_index.dart';
import '../../../../shared/widgets/app_button.dart';
import '../providers/auth_provider.dart';
import '../widgets/sign_up_buttons.dart';

class SignUpPage extends ConsumerStatefulWidget {
  final bool isFromWelcome;

  const SignUpPage({super.key, this.isFromWelcome = false});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  late final TextEditingController _fullNameController;
  late final TextEditingController _passwordController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _passwordController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _dateController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authAction = ref.watch(authActionProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar(
        title: AppString.newAccount,
        onBackPressed: widget.isFromWelcome
            ? () => context.goNamed(AppRouteNames.welcomeScreen)
            : () => context.pop(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              spacing: 20,
              children: [
                const SizedBox(height: 8),
                CustomTextField(
                  hintText: 'Enter your full name',
                  labelText: AppString.fullNameText,
                  controller: _fullNameController,
                ),
                CustomTextField(
                  hintText: AppString.hintPassword,
                  labelText: AppString.passwordTitle,
                  isPassword: true,
                  controller: _passwordController,
                ),
                CustomTextField(
                  hintText: 'example@example.com',
                  labelText: AppString.emailText,
                  controller: _emailController,
                ),
                CustomTextField(
                  hintText: 'Enter your phone number',
                  keyboardType: TextInputType.phone,
                  isPhone: true,
                  labelText: AppString.phonemeNumberField,
                  controller: _phoneController,
                ),
                CustomTextField(
                  hintText: 'DD/MM/YYYY',
                  isDate: true,
                  labelText: AppString.dateOfBitrh,
                  controller: _dateController,
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
                  padding: const EdgeInsets.symmetric(horizontal: 70),
                  child: AppButton(
                    title: AppString.signUp,
                    onPressed: authAction.isLoading
                        ? () {}
                        : () async {
                            await ref.read(authActionProvider.notifier).signUpWithEmail(
                                  fullName: _fullNameController.text.trim(),
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim(),
                                  phoneNumber: _phoneController.text.trim(),
                                  dateOfBirth: _dateController.text.trim(),
                                );
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
                  ),
                ),
                if (authAction.isLoading)
                  const Center(child: CircularProgressIndicator()),
                Center(
                  child: Text(
                    AppString.orSignUpText,
                    textAlign: TextAlign.center,
                    style: AppStyles.leagueSpartan12W300,
                  ),
                ),
                const SingUpButtons(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppString.alreadyHaveAccount,
                      style: AppStyles.leagueSpartan12W300,
                    ),
                    const SizedBox(width: 4),
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
