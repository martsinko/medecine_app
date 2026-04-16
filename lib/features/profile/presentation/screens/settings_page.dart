import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medicity_app/core/constants/app_index.dart';

import '../widgets/profile_components.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
          child: Column(
            children: [
              const ProfileTopBar(title: 'Settings'),
              const SizedBox(height: 44),
              SettingsTile(
                icon: Icons.lightbulb_outline_rounded,
                title: 'Notification Setting',
                onTap: () =>
                    context.pushNamed(AppRouteNames.notificationSettingsPage),
              ),
              SettingsTile(
                icon: Icons.key_outlined,
                title: 'Password Manager',
                onTap: () => _showComingSoon(context, 'Password Manager'),
              ),
              SettingsTile(
                icon: Icons.person_outline_rounded,
                title: 'Delete Account',
                onTap: () => _showComingSoon(context, 'Delete Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String title) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$title is not implemented yet.')));
  }
}
