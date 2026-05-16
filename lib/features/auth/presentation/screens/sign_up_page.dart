import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medicity_app/shared/widgets/custom_appbar.dart';
import 'package:medicity_app/shared/widgets/custom_textfield.dart';

import '../../../../core/constants/app_index.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../shared/widgets/app_button.dart';
import '../providers/auth_provider.dart';

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
        title: context.tr('newAccount'),
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
                  hintText: context.tr('enterFullName'),
                  labelText: context.tr('fullName'),
                  controller: _fullNameController,
                ),
                CustomTextField(
                  hintText: context.tr('enterPassword'),
                  labelText: context.tr('password'),
                  isPassword: true,
                  controller: _passwordController,
                ),
                CustomTextField(
                  hintText: 'example@example.com',
                  labelText: context.tr('email'),
                  controller: _emailController,
                ),
                CustomTextField(
                  hintText: context.tr('enterPhoneNumber'),
                  keyboardType: TextInputType.phone,
                  isPhone: true,
                  labelText: context.tr('mobileNumber'),
                  controller: _phoneController,
                ),
                CustomTextField(
                  hintText: 'DD/MM/YYYY',
                  isDate: true,
                  labelText: context.tr('dateOfBirth'),
                  controller: _dateController,
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: AppStyles.leagueSpartan12W300,
                    children: [
                      TextSpan(text: context.tr('byContinuing')),
                      TextSpan(
                        text: '\n${context.tr('termsOfUse')}',
                        style: AppStyles.leagueSpartan12W300.copyWith(
                          color: AppColors.welcomeBlue,
                          fontWeight: FontWeight.w600,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                      TextSpan(text: ' ${context.tr('and')} '),
                      TextSpan(
                        text: context.tr('privacyPolicy'),
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
                    title: context.tr('signUp'),
                    onPressed: authAction.isLoading
                        ? () {}
                        : () async {
                            await ref
                                .read(authActionProvider.notifier)
                                .signUpWithEmail(
                                  fullName: _fullNameController.text.trim(),
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim(),
                                  phoneNumber: _phoneController.text.trim(),
                                  dateOfBirth: _dateController.text.trim(),
                                );
                            final state = ref.read(authActionProvider);
                            if (state.hasError && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(context.trError(state.error!)),
                                ),
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
                // Social auth is temporarily disabled until native
                // Google/Facebook configuration is ready.
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.tr('alreadyHaveAccount'),
                      style: AppStyles.leagueSpartan12W300,
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => context.pushNamed(AppRouteNames.loginPage),
                      child: Text(
                        context.tr('login'),
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
