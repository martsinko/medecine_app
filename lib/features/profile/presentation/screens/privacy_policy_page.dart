import 'package:flutter/material.dart';
import 'package:medicity_app/core/constants/app_index.dart';

import '../data/profile_mock.dart';
import '../widgets/profile_components.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 20),
          child: ListView(
            children: [
              const ProfileTopBar(title: 'Privacy Policy'),
              const SizedBox(height: 18),
              Text(
                'Last Update: 14/08/2024',
                style: AppStyles.leagueSpartan12W300.copyWith(
                  color: AppColors.hintColor,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 10),
              for (final paragraph in privacyParagraphs) ...[
                Text(
                  paragraph,
                  style: AppStyles.leagueSpartan12W300.copyWith(
                    color: const Color(0xFF525252),
                    height: 1.18,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 12),
              ],
              Text(
                'Terms & Conditions',
                style: AppStyles.leagueSpartan20.copyWith(
                  color: AppColors.welcomeBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              for (int i = 0; i < privacyTerms.length; i++) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${i + 1}. ',
                      style: AppStyles.leagueSpartan12W300.copyWith(
                        color: const Color(0xFF525252),
                        fontSize: 13,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        privacyTerms[i],
                        style: AppStyles.leagueSpartan12W300.copyWith(
                          color: const Color(0xFF525252),
                          height: 1.18,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
