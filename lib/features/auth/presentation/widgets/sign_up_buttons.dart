import 'package:flutter/material.dart';

class SingUpButtons extends StatelessWidget {
  const SingUpButtons({super.key});

  @override
  Widget build(BuildContext context) {
    // Social auth buttons are temporarily disabled until Google/Facebook
    // native configuration is ready.
    return const SizedBox.shrink();
  }
}
