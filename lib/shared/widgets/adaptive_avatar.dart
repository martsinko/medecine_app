import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medicity_app/core/constants/app_images.dart';

class AdaptiveAvatar extends StatelessWidget {
  final String? imageSource;
  final double radius;

  const AdaptiveAvatar({
    super.key,
    required this.imageSource,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    final source = imageSource ?? '';
    final size = radius * 2;

    return ClipOval(
      child: Container(
        width: size,
        height: size,
        color: const Color(0xFFE6ECFF),
        child: _buildImage(source),
      ),
    );
  }

  Widget _buildImage(String source) {
    if (source.isEmpty) {
      return Image.asset(AppImages.exampleAvatar, fit: BoxFit.cover);
    }

    if (source.startsWith('http') && source.toLowerCase().endsWith('.svg')) {
      return SvgPicture.network(
        source,
        fit: BoxFit.cover,
        placeholderBuilder: (_) =>
            Image.asset(AppImages.exampleAvatar, fit: BoxFit.cover),
      );
    }

    if (source.startsWith('http')) {
      return Image.network(
        source,
        fit: BoxFit.cover,
        errorBuilder: (_, error, stackTrace) =>
            Image.asset(AppImages.exampleAvatar, fit: BoxFit.cover),
      );
    }

    return Image.asset(
      source,
      fit: BoxFit.cover,
      errorBuilder: (_, error, stackTrace) =>
          Image.asset(AppImages.exampleAvatar, fit: BoxFit.cover),
    );
  }
}
