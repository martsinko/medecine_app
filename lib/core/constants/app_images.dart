abstract final class AppImages {
  static String _buildPath(String name) => 'assets/images/$name';

  static final String backgroundWelcomeImage = _buildPath('welcome.png');
  static final String backgroundWelcomeImage2 = _buildPath('welcome2.png');
  static final String tryAvatarImage = _buildPath('try_avatar.png');
  static final String exampleAvatar = _buildPath('example_avatar.png');

}

abstract final class AppIcons {
  static String _buildPath(String name) => 'assets/icons/$name';

  static final String commentIcon = _buildPath('comment_icon.png');
  static final String doctorsIcon = _buildPath('doctors_icon.png');
  static final String facebookIcon = _buildPath('facebook_icon.png');
  static final String favouriteIcon = _buildPath('favourite_icon.png');
  static final String filtersIcon = _buildPath('filters_icon.png');
  static final String googleIcon = _buildPath('google_icon.png');
  static final String lowStarIcon = _buildPath('low_star_icon.png');
  static final String miniFavouriteIcon = _buildPath('mini_favourite_icon.png');
  static final String miniNonfavouriteIcon = _buildPath(
    'mini_nonfavourite_icon.png',
  );

  static final String navBarIcon1 = _buildPath('nav_bar_icon1.png');
  static final String navBarIcon2 = _buildPath('nav_bar_icon2.png');
  static final String navBarIcon3 = _buildPath('nav_bar_icon3.png');
  static final String navBarIcon4 = _buildPath('nav_bar_icon4.png');

  static final String notificationIcon = _buildPath('notification_icon.png');
  static final String questionIcon = _buildPath('question_icon.png');
  static final String searchIcon = _buildPath('search_icon.png');
  static final String settingsIcon = _buildPath('settings_icon.png');
  static final String starIcon = _buildPath('star_icon.png');
  static final String touchIcon = _buildPath('touch_icon.png');
}
