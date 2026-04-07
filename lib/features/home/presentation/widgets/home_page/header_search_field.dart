import 'package:flutter/material.dart';

import '../../../../../core/constants/app_index.dart';

class HeaderSearchField extends StatelessWidget {
  const HeaderSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 44,
        child: TextFormField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 8.0),
            filled: true,
            fillColor: AppColors.signUpButtonBlue,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(26.0),
              borderSide: BorderSide.none,
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Image.asset(AppIcons.searchIcon, height: 12),
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 4),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10.5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(AppIcons.filtersIcon, height: 9, width: 12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
