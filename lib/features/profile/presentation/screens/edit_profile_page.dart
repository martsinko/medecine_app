import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medicity_app/core/constants/app_index.dart';

import '../data/profile_mock.dart';
import '../models/profile_models.dart';
import '../providers/profile_provider.dart';
import '../widgets/profile_components.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  late final TextEditingController _fullNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileProvider).value ?? initialProfileData;
    _fullNameController = TextEditingController(text: profile.fullName);
    _phoneController = TextEditingController(text: profile.phoneNumber);
    _emailController = TextEditingController(text: profile.email);
    _dateController = TextEditingController(text: profile.dateOfBirth);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider).value ?? initialProfileData;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 32),
          child: Column(
            children: [
              ProfileTopBar(
                title: 'Profile',
                trailing: InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: () => context.pushNamed(AppRouteNames.settingsPage),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: AppColors.welcomeBlue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.settings_outlined,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(child: ProfileAvatar(imagePath: profile.avatarPath)),
              const SizedBox(height: 32),
              Expanded(
                child: ListView(
                  children: [
                    ProfileFormField(
                      label: 'Full Name',
                      controller: _fullNameController,
                    ),
                    const SizedBox(height: 22),
                    ProfileFormField(
                      label: 'Phone Number',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 22),
                    ProfileFormField(
                      label: 'Email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 22),
                    ProfileFormField(
                      label: 'Date Of Birth',
                      controller: _dateController,
                      hintText: 'DD / MM / YYYY',
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 238,
                child: ProfilePrimaryButton(
                  label: 'Update Profile',
                  onTap: () {
                    ref
                        .read(profileActionProvider.notifier)
                        .update(
                          ProfileData(
                            uid: profile.uid,
                            fullName: _fullNameController.text.trim(),
                            phoneNumber: _phoneController.text.trim(),
                            email: _emailController.text.trim(),
                            dateOfBirth: _dateController.text.trim(),
                            avatarPath: profile.avatarPath,
                            favoriteTeacherIds: profile.favoriteTeacherIds,
                            notificationPreferences:
                                profile.notificationPreferences,
                          ),
                        );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile updated.')),
                    );
                    context.pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
