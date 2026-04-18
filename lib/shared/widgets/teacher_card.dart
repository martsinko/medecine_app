import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_index.dart';
import '../../features/home/presentation/widgets/home_page/info_container.dart';
import 'adaptive_avatar.dart';
import 'small_button.dart';

class TeacherCard extends StatelessWidget {
  final String name;
  final String description;
  final double rating;
  final int comments;
  final String? imagePath;
  final String? teacherId;
  const TeacherCard({
    super.key,
    required this.description,
    required this.name,
    required this.comments,
    required this.rating,
    this.imagePath,
    this.teacherId,
  });

  @override
  Widget build(BuildContext context) {
    final newRating = rating == 5
        ? rating.toInt().toString()
        : rating.toString();
    return Container(
      padding: const EdgeInsets.only(left: 13, right: 9, top: 9, bottom: 6),
      decoration: BoxDecoration(
        color: AppColors.signUpButtonBlue,
        borderRadius: BorderRadius.circular(17),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: AdaptiveAvatar(
                imageSource: imagePath ?? AppImages.exampleAvatar,
                radius: 40,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: AppStyles.leagueSpartan14),
                        Text(description, style: AppStyles.leagueSpartan12W300),
                      ],
                    ),
                  ),
                  SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InfoContainer(title: newRating, icon: Icons.star_border),
                      SizedBox(width: 6),
                      InfoContainer(
                        title: comments.toString(),
                        icon: Icons.comment_outlined,
                      ),
                      Spacer(),
                      SmallButton(
                        onTap: () {
                          if (teacherId != null) {
                            context.goNamed(
                              AppRouteNames.doctorInfoPage,
                              pathParameters: {'doctorId': teacherId!},
                            );
                          }
                        },
                        icon: Icons.question_mark,
                      ),
                      const SizedBox(width: 1),
                      SmallButton(
                        onTap: () {
                          if (teacherId != null) {
                            context.goNamed(AppRouteNames.wishlistPage);
                          }
                        },
                        icon: Icons.favorite,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
