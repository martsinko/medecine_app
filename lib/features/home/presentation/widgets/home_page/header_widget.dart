import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_index.dart';
import 'avatar_button.dart';
import 'avatar_widget.dart';
import 'header_button.dart';
import 'header_search_field.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Column(
        children: [
          Row(
            children: [
              AvatarWidget(),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.welcomeBackText,
                      style: AppStyles.leagueSpartan12W300.copyWith(
                        color: AppColors.welcomeBlue,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text('John Doe', style: AppStyles.leagueSpartan16),
                  ],
                ),
              ),
              AvatarButton(imagePath: AppIcons.notificationIcon),
              SizedBox(width: 8),
              AvatarButton(),
            ],
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              HeaderButton(
                imagePath: AppIcons.doctorsIcon,
                title: AppString.doctorsText,
                onTap: () => context.pushNamed(AppRouteNames.doctorsPage),
              ),
              const SizedBox(width: 12),
              HeaderButton(
                imagePath: AppIcons.favouriteIcon,
                title: AppString.favouriteText,
                onTap: () {},
              ),
              const SizedBox(width: 20),
              HeaderSearchField(),
            ],
          ),
        ],
      ),
    );
  }
}
