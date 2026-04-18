import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medicity_app/core/constants/app_index.dart';

import '../data/doctors_mock.dart';
import '../models/doctor_profile.dart';
import '../providers/teacher_provider.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../widgets/doctors/doctor_components.dart';

class FavoritePage extends ConsumerStatefulWidget {
  const FavoritePage({super.key});

  @override
  ConsumerState<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends ConsumerState<FavoritePage> {
  bool _showServices = false;
  int _expandedServiceIndex = 0;
  DoctorGender? _selectedGender;

  @override
  Widget build(BuildContext context) {
    return ref
        .watch(teachersProvider)
        .when(
          data: (teachers) {
            final filteredDoctors = _buildDisplayedDoctors(teachers);
            return Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 120),
                    children: [
                      DoctorsTopBar(title: _pageTitle),
                      const SizedBox(height: 16),
                      DoctorsFilterRow(
                        highlight: _showServices
                            ? DoctorsFilterHighlight.favorite
                            : DoctorsFilterHighlight.none,
                        showGenderFilters: true,
                        favoriteSelected:
                            _showServices || _selectedGender == null,
                        selectedGender: _selectedGender,
                        onRatingTap: () =>
                            context.goNamed(AppRouteNames.ratingPage),
                        onFavoriteTap: () {
                          setState(() {
                            _showServices = false;
                            _selectedGender = null;
                          });
                        },
                        onFemaleTap: () => _selectGender(DoctorGender.female),
                        onMaleTap: () => _selectGender(DoctorGender.male),
                      ),
                      const SizedBox(height: 20),
                      _FavoriteTabs(
                        showServices: _showServices,
                        onSelect: (value) {
                          setState(() {
                            _showServices = value;
                            if (value) {
                              _selectedGender = null;
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 14),
                      if (_showServices) ...[
                        for (
                          int i = 0;
                          i < favoriteServicesMock.length;
                          i++
                        ) ...[
                          _ServiceCategoryTile(
                            category: favoriteServicesMock[i],
                            expanded: _expandedServiceIndex == i,
                            onTap: () {
                              setState(() {
                                _expandedServiceIndex = i;
                              });
                            },
                          ),
                          if (_expandedServiceIndex == i) ...[
                            const SizedBox(height: 12),
                            if (i == 0)
                              PrimaryPillButton(
                                label: 'looking teachers',
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                onTap: () =>
                                    context.goNamed(AppRouteNames.doctorsPage),
                              ),
                          ],
                          const SizedBox(height: 12),
                        ],
                      ] else ...[
                        for (final doctor in filteredDoctors)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: DoctorCompactCard(
                              doctor: doctor,
                              onInfoTap: () => context.goNamed(
                                AppRouteNames.doctorInfoPage,
                                pathParameters: {'doctorId': doctor.id},
                              ),
                              onCalendarTap: () => context.goNamed(
                                AppRouteNames.scheduleDoctorPage,
                                pathParameters: {'doctorId': doctor.id},
                              ),
                              onDetailsTap: () => context.goNamed(
                                AppRouteNames.doctorInfoPage,
                                pathParameters: {'doctorId': doctor.id},
                              ),
                              onFavoriteTap: () => ref
                                  .read(profileActionProvider.notifier)
                                  .toggleFavoriteTeacher(
                                    doctor.id,
                                    !doctor.isFavorite,
                                  ),
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
          loading: () => const Scaffold(
            body: SafeArea(child: Center(child: CircularProgressIndicator())),
          ),
          error: (error, stackTrace) => const Scaffold(
            body: SafeArea(
              child: Center(child: Text('Failed to load favorites.')),
            ),
          ),
        );
  }

  String get _pageTitle {
    if (_showServices) {
      return 'Favorite';
    }

    return switch (_selectedGender) {
      DoctorGender.female => 'Female',
      DoctorGender.male => 'Male',
      null => 'Favorite',
    };
  }

  void _selectGender(DoctorGender gender) {
    setState(() {
      _showServices = false;
      _selectedGender = _selectedGender == gender ? null : gender;
    });
  }

  List<DoctorProfile> _buildDisplayedDoctors(List<DoctorProfile> teachers) {
    final doctors = teachers
        .where((teacher) => teacher.isFavorite)
        .where(
          (teacher) =>
              _selectedGender == null || teacher.gender == _selectedGender,
        )
        .toList();
    if (_selectedGender == null || doctors.length > 2) {
      return doctors;
    }

    return [...doctors, ...doctors];
  }
}

class _FavoriteTabs extends StatelessWidget {
  final bool showServices;
  final ValueChanged<bool> onSelect;

  const _FavoriteTabs({required this.showServices, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.signUpButtonBlue,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          Expanded(
            child: _FavoriteTabButton(
              label: 'Teachers',
              selected: !showServices,
              onTap: () => onSelect(false),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _FavoriteTabButton(
              label: 'Services',
              selected: showServices,
              onTap: () => onSelect(true),
            ),
          ),
        ],
      ),
    );
  }
}

class _FavoriteTabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FavoriteTabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.welcomeBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppStyles.leagueSpartan16.copyWith(
            color: selected ? Colors.white : AppColors.welcomeBlue,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _ServiceCategoryTile extends StatelessWidget {
  final FavoriteServiceCategory category;
  final bool expanded;
  final VoidCallback onTap;

  const _ServiceCategoryTile({
    required this.category,
    required this.expanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: expanded ? AppColors.signUpButtonBlue : AppColors.welcomeBlue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.favorite_rounded,
                      color: expanded ? AppColors.welcomeBlue : Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        category.title,
                        style: AppStyles.leagueSpartan16.copyWith(
                          color: expanded
                              ? AppColors.welcomeBlue
                              : Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Icon(
                      expanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: expanded ? AppColors.welcomeBlue : Colors.white,
                      size: 28,
                    ),
                  ],
                ),
                if (expanded) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5EBFF),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      category.description,
                      style: AppStyles.leagueSpartan12W300.copyWith(
                        fontSize: 14,
                        height: 1.2,
                        color: const Color(0xFF4A4A4A),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
