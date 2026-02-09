import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_index.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBack;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;

  const CustomAppbar({
    super.key,
    this.title,
    this.showBack = true,
    this.actions,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: title != null
          ? Text(
              title!,
              style: AppStyles.leagueSpartan24.copyWith(
                color: AppColors.welcomeBlue,
                fontWeight: FontWeight.w700,
              ),
            )
          : null,
      leading: showBack
          ? Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.welcomeBlue,
                ),
                onPressed: onBackPressed ?? () => context.pop(),
              ),
            )
          : null,
      actions: actions,
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
