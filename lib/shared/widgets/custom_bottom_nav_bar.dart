import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_index.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final GoRouterState state;
  final Widget child;
  const CustomBottomNavigationBar({
    super.key,
    required this.state,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final currentPath = state.uri.path;
    final isHome = currentPath == AppRoutePaths.homePage;
    final isWishlist = currentPath == AppRoutePaths.wishlistPage;
    final isProfile = currentPath == AppRoutePaths.profilePage;
    final isAppointments =
        currentPath.startsWith(AppRoutePaths.appointmentsPage) ||
        currentPath.startsWith('/schedule');
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          bottom: 34,
          top: 16,
          left: 30,
          right: 30,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.welcomeBlue,
            borderRadius: BorderRadius.circular(50),
          ),

          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 14.0,
              horizontal: 27.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _NavigationItem(
                  icon: AppIcons.navBarIcon1,
                  selected: isHome,
                  onTap: () => context.goNamed(AppRouteNames.homePage),
                ),
                _NavigationItem(
                  selected: isWishlist,
                  icon: AppIcons.navBarIcon2,
                  onTap: () => context.goNamed(AppRouteNames.wishlistPage),
                ),
                _NavigationItem(
                  selected: isProfile,
                  icon: AppIcons.navBarIcon3,
                  onTap: () => context.goNamed(AppRouteNames.profilePage),
                ),
                _NavigationItem(
                  selected: isAppointments,
                  icon: AppIcons.navBarIcon4,
                  onTap: () => context.goNamed(AppRouteNames.appointmentsPage),
                ),
              ],
            ),
          ),
        ),
      ),
      body: child,
    );
  }
}

class _NavigationItem extends StatelessWidget {
  final String icon;
  final VoidCallback? onTap;
  final bool selected;

  const _NavigationItem({
    required this.icon,
    required this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox.square(
              dimension: 28,
              child: selected
                  ? Image.asset(icon, color: Colors.black)
                  : Image.asset(icon),
            ),
          ],
        ),
      ),
    );
  }
}
