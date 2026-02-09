abstract final class AppImages {
  static String _buildPath(String name) => 'assets/images/$name';

  static final String backgroundWelcomeImage = _buildPath('welcome.png');
  static final String backgroundWelcomeImage2 = _buildPath('welcome2.png');
}

abstract final class AppIcons {
  static String _buildPath(String name) => 'assets/icons/$name';

  static final String facebookIcon = _buildPath('facebook_icon.png');
  static final String googleIcon = _buildPath('google_icon.png');
  static final String touchIcon = _buildPath('touch_icon.png');
}
