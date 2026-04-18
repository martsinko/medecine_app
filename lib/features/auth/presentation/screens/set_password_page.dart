import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medicity_app/core/constants/app_index.dart';
import 'package:medicity_app/shared/widgets/app_button.dart';
import 'package:medicity_app/shared/widgets/custom_appbar.dart';
import 'package:medicity_app/shared/widgets/custom_textfield.dart';
import 'package:medicity_app/features/auth/presentation/providers/auth_provider.dart';

class SetPasswordPage extends ConsumerStatefulWidget {
  const SetPasswordPage({super.key});

  @override
  ConsumerState<SetPasswordPage> createState() => _SetPasswordPageState();
}

class _SetPasswordPageState extends ConsumerState<SetPasswordPage> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFromSettings = ModalRoute.of(context)?.settings.name == 'set_password';
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar(
        title: isFromSettings ? 'Password Manager' : AppString.setPasswordTitle,
        onBackPressed: () => context.pop(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              if (isFromSettings) ...[
                Text(
                  'Change your password',
                  style: AppStyles.leagueSpartan16,
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter your current password and create a new one',
                  style: AppStyles.leagueSpartan12W300,
                ),
              ] else ...[
                Text(
                  AppString.welcomeLatinText,
                  style: AppStyles.leagueSpartan12W300,
                ),
              ],
              const SizedBox(height: 32),
              if (isFromSettings) ...[
                CustomTextField(
                  controller: _currentPasswordController,
                  hintText: 'Current password',
                  labelText: 'Current Password',
                  isPassword: true,
                ),
                const SizedBox(height: 20),
              ],
              CustomTextField(
                controller: _newPasswordController,
                hintText: AppString.hintPassword,
                labelText: 'New Password',
                isPassword: true,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _confirmPasswordController,
                hintText: AppString.hintPassword,
                labelText: AppString.confirmPasswordTitle,
                isPassword: true,
              ),
              const SizedBox(height: 48),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : AppButton(
                        title: isFromSettings ? 'Update Password' : AppString.createNewPassword,
                        onPressed: () => _handlePasswordChange(context, isFromSettings),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handlePasswordChange(BuildContext context, bool isFromSettings) async {
    final current = _currentPasswordController.text.trim();
    final newPass = _newPasswordController.text.trim();
    final confirm = _confirmPasswordController.text.trim();

    if (newPass.isEmpty || confirm.isEmpty) {
      _showSnackBar(context, 'Please fill in all password fields');
      return;
    }

    if (newPass.length < 6) {
      _showSnackBar(context, 'Password must be at least 6 characters');
      return;
    }

    if (newPass != confirm) {
      _showSnackBar(context, 'Passwords do not match');
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (isFromSettings && current.isNotEmpty) {
        await ref.read(authActionProvider.notifier).changePassword(current, newPass);
      } else if (!isFromSettings) {
        await Future.delayed(const Duration(milliseconds: 500));
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isFromSettings ? 'Password updated!' : 'Password created!'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (context.mounted) {
        _showSnackBar(context, e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}