import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medicity_app/core/constants/app_index.dart';
import 'package:medicity_app/shared/widgets/app_button.dart';
import 'package:medicity_app/shared/widgets/custom_appbar.dart';
import 'package:medicity_app/shared/widgets/custom_textfield.dart';
import 'package:medicity_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:medicity_app/core/localization/app_localizations.dart';

class SetPasswordPage extends ConsumerStatefulWidget {
  final bool isPasswordManager;

  const SetPasswordPage({super.key, this.isPasswordManager = false});

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
    final isPasswordManager = widget.isPasswordManager;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar(
        title: isPasswordManager
            ? context.tr('passwordManager')
            : context.tr('setPassword'),
        onBackPressed: () => context.pop(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              if (isPasswordManager) ...[
                Text(
                  context.tr('changePassword'),
                  style: AppStyles.leagueSpartan16,
                ),
                const SizedBox(height: 8),
                Text(
                  context.tr('changePasswordDescription'),
                  style: AppStyles.leagueSpartan12W300,
                ),
              ] else ...[
                Text(
                  context.tr('welcomeDescription'),
                  style: AppStyles.leagueSpartan12W300,
                ),
              ],
              const SizedBox(height: 32),
              if (isPasswordManager) ...[
                CustomTextField(
                  controller: _currentPasswordController,
                  hintText: context.tr('currentPassword'),
                  labelText: context.tr('currentPassword'),
                  isPassword: true,
                ),
                const SizedBox(height: 20),
              ],
              CustomTextField(
                controller: _newPasswordController,
                hintText: context.tr('enterPassword'),
                labelText: context.tr('newPassword'),
                isPassword: true,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _confirmPasswordController,
                hintText: context.tr('enterPassword'),
                labelText: context.tr('confirmPassword'),
                isPassword: true,
              ),
              const SizedBox(height: 48),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : AppButton(
                        title: isPasswordManager
                            ? context.tr('updatePassword')
                            : context.tr('createNewPassword'),
                        onPressed: () =>
                            _handlePasswordChange(context, isPasswordManager),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handlePasswordChange(
    BuildContext context,
    bool isPasswordManager,
  ) async {
    final current = _currentPasswordController.text.trim();
    final newPass = _newPasswordController.text.trim();
    final confirm = _confirmPasswordController.text.trim();

    if (isPasswordManager && current.isEmpty) {
      _showSnackBar(context, context.tr('enterCurrentPassword'));
      return;
    }

    if (newPass.isEmpty || confirm.isEmpty) {
      _showSnackBar(context, context.tr('pleaseFillPasswordFields'));
      return;
    }

    if (newPass.length < 6) {
      _showSnackBar(context, context.tr('passwordTooShort'));
      return;
    }

    if (newPass != confirm) {
      _showSnackBar(context, context.tr('passwordsDoNotMatch'));
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (isPasswordManager) {
        await ref
            .read(authActionProvider.notifier)
            .changePassword(current, newPass);
      } else {
        await Future.delayed(const Duration(milliseconds: 500));
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isPasswordManager
                  ? context.tr('passwordUpdated')
                  : context.tr('passwordCreated'),
            ),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (context.mounted) {
        _showSnackBar(context, context.trError(e));
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
