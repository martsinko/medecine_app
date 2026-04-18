import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medicity_app/core/constants/app_index.dart';
import 'package:medicity_app/features/profile/presentation/providers/profile_provider.dart';
import 'package:medicity_app/features/home/presentation/widgets/home_page/info_container.dart';
import 'adaptive_avatar.dart';
import 'small_button.dart';

class TeacherCard extends ConsumerWidget {
  final String name;
  final String description;
  final double rating;
  final int comments;
  final String? imagePath;
  final String? teacherId;
  final bool isFavorite;

  const TeacherCard({
    super.key,
    required this.description,
    required this.name,
    required this.comments,
    required this.rating,
    this.imagePath,
    this.teacherId,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newRating = rating == 5
        ? rating.toInt().toString()
        : rating.toString();
    
    return Container(
      padding: EdgeInsetsGeometry.only(left: 13, right: 9, top: 9, bottom: 6),
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
                      SmallButton(onTap: () {}, icon: Icons.question_mark),
                      SizedBox(width: 1),
                      SmallButton(
                        onTap: () async {
                          if (teacherId != null) {
                            final userId = ref.read(currentUserIdProvider);
                            if (userId != null) {
                              await ref
                                  .read(profileActionProvider.notifier)
                                  .toggleFavoriteTeacher(
                                    teacherId!,
                                    !isFavorite,
                                  );
                            } else {
                              if (context.mounted) {
                                context.goNamed(AppRouteNames.loginPage);
                              }
                            }
                          }
                        },
                        icon: isFavorite ? Icons.favorite : Icons.favorite_border,
                        selected: isFavorite,
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