import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medicity_app/core/constants/app_index.dart';
import 'package:medicity_app/core/firebase/firebase_providers.dart';
import 'package:medicity_app/core/localization/app_localizations.dart';
import 'package:medicity_app/features/auth/presentation/providers/auth_provider.dart';

import '../widgets/profile_components.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
          child: Column(
            children: [
              ProfileTopBar(title: context.tr('settings')),
              const SizedBox(height: 44),
              SettingsTile(
                icon: Icons.lightbulb_outline_rounded,
                title: context.tr('notificationSetting'),
                onTap: () =>
                    context.pushNamed(AppRouteNames.notificationSettingsPage),
              ),
              SettingsTile(
                icon: Icons.key_outlined,
                title: context.tr('passwordManager'),
                onTap: () =>
                    context.pushNamed(AppRouteNames.setPassword, extra: true),
              ),
              SettingsTile(
                icon: Icons.person_outline_rounded,
                title: context.tr('deleteAccount'),
                onTap: () => _showDeleteAccountDialog(context, ref),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDeleteAccountDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final rootContext = context;
    final user = ref.read(authStateChangesProvider).value;
    if (user == null) {
      rootContext.goNamed(AppRouteNames.loginPage);
      return;
    }

    final requiresPassword = user.providerData.any(
      (provider) => provider.providerId == 'password',
    );
    final passwordController = TextEditingController();
    var isDeleting = false;

    await showDialog<void>(
      context: context,
      barrierDismissible: !isDeleting,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContentContext, setDialogState) {
            return AlertDialog(
              title: Text(rootContext.tr('deleteAccount')),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(rootContext.tr('deleteAccountWarning')),
                  if (requiresPassword) ...[
                    const SizedBox(height: 16),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: rootContext.tr('currentPassword'),
                        hintText: rootContext.tr('enterPassword'),
                      ),
                    ),
                  ] else ...[
                    const SizedBox(height: 12),
                    Text(rootContext.tr('socialAccountConfirm')),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isDeleting
                      ? null
                      : () => dialogContentContext.pop(),
                  child: Text(rootContext.tr('cancel')),
                ),
                TextButton(
                  onPressed: isDeleting
                      ? null
                      : () async {
                          final password = passwordController.text.trim();
                          if (requiresPassword && password.isEmpty) {
                            _showSnackBar(
                              rootContext,
                              rootContext.tr('enterCurrentPassword'),
                              isError: true,
                            );
                            return;
                          }

                          setDialogState(() => isDeleting = true);
                          await ref
                              .read(authActionProvider.notifier)
                              .deleteAccount(
                                password: requiresPassword ? password : null,
                              );
                          final state = ref.read(authActionProvider);

                          if (!dialogContentContext.mounted ||
                              !rootContext.mounted) {
                            return;
                          }

                          setDialogState(() => isDeleting = false);
                          state.whenOrNull(
                            data: (_) {
                              dialogContentContext.pop();
                              _showSnackBar(
                                rootContext,
                                rootContext.tr('accountDeleted'),
                              );
                              rootContext.goNamed(AppRouteNames.welcomeScreen);
                            },
                            error: (error, _) {
                              _showSnackBar(
                                rootContext,
                                rootContext.tr(_friendlyAuthError(error)),
                                isError: true,
                              );
                            },
                          );
                        },
                  child: isDeleting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(rootContext.tr('delete')),
                ),
              ],
            );
          },
        );
      },
    );

    passwordController.dispose();
  }

  void _showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  String _friendlyAuthError(Object error) {
    final message = error.toString();
    if (message.contains('wrong-password') ||
        message.contains('invalid-credential')) {
      return 'wrongPassword';
    }
    if (message.contains('requires-recent-login')) {
      return 'recentLoginRequired';
    }
    if (message.contains('google_reauth_cancelled')) {
      return 'googleCancelled';
    }
    if (message.contains('facebook_sign_in_cancelled')) {
      return 'facebookCancelled';
    }
    return message.replaceFirst('Exception: ', '');
  }
}
