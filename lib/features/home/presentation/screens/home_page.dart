import 'package:flutter/material.dart';
import '../../../../core/constants/app_index.dart';
import '../widgets/header_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.signUpButtonBlue,
      body: SafeArea(child: Column(children: [HeaderWidget()])),
    );
  }
}
