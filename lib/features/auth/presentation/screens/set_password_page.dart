import 'package:flutter/material.dart';
import 'package:medicity_app/core/constants/app_index.dart';
import 'package:medicity_app/shared/widgets/app_button.dart';
import 'package:medicity_app/shared/widgets/custom_appbar.dart';
import 'package:medicity_app/shared/widgets/custom_textfield.dart';

class SetPasswordPage extends StatelessWidget {
  const SetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar(
        title: AppString.setPasswordTitle,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 30),
          child: Column(
            children: [
              SizedBox(height: 12),
              Text(
                AppString.welcomeLatinText,
                style: AppStyles.leagueSpartan12W300,
              ),
              SizedBox(height: 32),
              CustomTextField(
                hintText: AppString.hintPassword,
                labelText: AppString.passwordTitle,
                isPassword: true,
              ),
              SizedBox(height: 30),
              CustomTextField(
                hintText: AppString.hintPassword,
                labelText: AppString.confirmPasswordTitle,
                isPassword: true,
              ),
              SizedBox(height: 48),
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 12),
                child: AppButton(
                  title: AppString.createNewPassword,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
