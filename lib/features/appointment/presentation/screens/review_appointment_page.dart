import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medicity_app/core/constants/app_index.dart';
import 'package:medicity_app/features/home/presentation/providers/teacher_provider.dart';
import 'package:medicity_app/shared/widgets/adaptive_avatar.dart';

import '../providers/appointment_provider.dart';
import '../widgets/appointment_components.dart';

class ReviewAppointmentPage extends ConsumerStatefulWidget {
  final String appointmentId;

  const ReviewAppointmentPage({super.key, required this.appointmentId});

  @override
  ConsumerState<ReviewAppointmentPage> createState() =>
      _ReviewAppointmentPageState();
}

class _ReviewAppointmentPageState extends ConsumerState<ReviewAppointmentPage> {
  late final TextEditingController _commentController;
  int _selectedStars = 4;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ref
        .watch(appointmentsProvider)
        .when(
          data: (appointments) {
            final appointment = findAppointmentById(
              appointments,
              widget.appointmentId,
            );
            if (appointment == null) {
              return const Scaffold(body: SafeArea(child: SizedBox.shrink()));
            }

            return ref
                .watch(teacherByIdProvider(appointment.doctorId))
                .when(
                  data: (teacher) {
                    if (teacher == null) {
                      return const Scaffold(
                        body: SafeArea(child: SizedBox.shrink()),
                      );
                    }

                    return Scaffold(
                      backgroundColor: Colors.white,
                      body: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
                          child: ListView(
                            padding: const EdgeInsets.only(bottom: 120),
                            children: [
                              const AppointmentTopBar(title: 'Review'),
                              const SizedBox(height: 16),
                              Text(
                                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                                style: AppStyles.leagueSpartan12W300.copyWith(
                                  color: const Color(0xFF5E5E5E),
                                  fontSize: 14,
                                  height: 1.18,
                                ),
                              ),
                              const SizedBox(height: 24),
                              CircleAvatar(
                                radius: 66,
                                backgroundColor: Colors.transparent,
                                child: AdaptiveAvatar(
                                  imageSource: teacher.imagePath,
                                  radius: 66,
                                ),
                              ),
                              const SizedBox(height: 18),
                              Text(
                                teacher.name,
                                textAlign: TextAlign.center,
                                style: AppStyles.leagueSpartan24.copyWith(
                                  color: AppColors.welcomeBlue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                teacher.specialty,
                                textAlign: TextAlign.center,
                                style: AppStyles.leagueSpartan16.copyWith(
                                  color: const Color(0xFF5E5E5E),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Center(
                                child: StarRatingRow(
                                  selectedStars: _selectedStars,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedStars = value;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                height: 150,
                                decoration: BoxDecoration(
                                  color: AppColors.fillColor,
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                child: TextField(
                                  controller: _commentController,
                                  maxLines: null,
                                  expands: true,
                                  decoration: InputDecoration(
                                    hintText: 'Enter Your Comment Here...',
                                    hintStyle: AppStyles.leagueSpartan16
                                        .copyWith(color: AppColors.hintColor),
                                    contentPadding: const EdgeInsets.all(18),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 34),
                              AppointmentActionButton(
                                label: 'Add Review',
                                onTap: () async {
                                  await ref
                                      .read(appointmentActionProvider.notifier)
                                      .addReview(
                                        appointment.id,
                                        stars: _selectedStars,
                                        comment: _commentController.text.trim(),
                                      );
                                  if (context.mounted) {
                                    context.goNamed(
                                      AppRouteNames.appointmentsPage,
                                      queryParameters: {'tab': 'complete'},
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  loading: () => const Scaffold(
                    body: SafeArea(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                  error: (error, stackTrace) => const Scaffold(
                    body: SafeArea(
                      child: Center(child: Text('Failed to load teacher.')),
                    ),
                  ),
                );
          },
          loading: () => const Scaffold(
            body: SafeArea(child: Center(child: CircularProgressIndicator())),
          ),
          error: (error, stackTrace) => const Scaffold(
            body: SafeArea(
              child: Center(child: Text('Failed to load appointment.')),
            ),
          ),
        );
  }
}
