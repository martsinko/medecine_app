import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medicity_app/shared/widgets/app_button.dart';

import '../../../../core/constants/app_index.dart';
import '../../../../shared/widgets/custom_appbar.dart';
import '../../../../shared/widgets/custom_textfield.dart';
import '../providers/auth_provider.dart';
import '../widgets/sign_up_buttons.dart';

class LogInPage extends ConsumerStatefulWidget {
  final bool isFromWelcome;

  const LogInPage({super.key, this.isFromWelcome = false});

  @override
  ConsumerState<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends ConsumerState<LogInPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authAction = ref.watch(authActionProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar(
        title: 'Log In',
        onBackPressed: widget.isFromWelcome
            ? () => context.goNamed(AppRouteNames.welcomeScreen)
            : () => context.pop(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 34),
              Text(
                AppString.loginTitle,
                style: AppStyles.leagueSpartan24.copyWith(
                  color: AppColors.welcomeBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                AppString.welcomeLatinText,
                style: AppStyles.leagueSpartan12W300,
              ),
              const SizedBox(height: 48),
              CustomTextField(
                labelText: AppString.emailField,
                hintText: 'example@example.com',
                controller: _emailController,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                labelText: AppString.passwordTitle,
                hintText: AppString.hintPassword,
                isPassword: true,
                controller: _passwordController,
              ),
              const SizedBox(height: 8),
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
              const SizedBox(height: 42),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 65),
                child: AppButton(
                  title: AppString.logIn,
                  onPressed: authAction.isLoading
                      ? () {}
                      : () async {
                          await ref.read(authActionProvider.notifier).signInWithEmail(
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
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
              if (authAction.isLoading) ...[
                const SizedBox(height: 16),
                const Center(child: CircularProgressIndicator()),
              ],
              const SizedBox(height: 16),
              Center(
                child: Text(
                  AppString.orSignUpText,
                  textAlign: TextAlign.center,
                  style: AppStyles.leagueSpartan12W300,
                ),
              ),
              const SizedBox(height: 12),
              const SingUpButtons(),
              const SizedBox(height: 38),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppString.dontHaveAccount,
                    style: AppStyles.leagueSpartan12W300,
                  ),
                  const SizedBox(width: 4),
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
