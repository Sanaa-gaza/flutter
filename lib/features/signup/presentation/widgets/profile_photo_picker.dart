import 'package:flutter/material.dart';
import 'package:flutter_sanaa_app/core/constants/app_icons.dart';
import 'package:flutter_sanaa_app/core/theme/app_colors.dart';
import 'package:flutter_sanaa_app/core/theme/app_text_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// The round profile photo slot with a small "+" badge and a label under it.
class ProfilePhotoPicker extends StatelessWidget {
  const ProfilePhotoPicker({
    super.key,
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  // Sizes from the Figma craftsman step 2 frame.
  static const double _circleSize = 110;
  static const double _iconSize = 27;
  static const double _badgeSize = 17;
  static const double _badgeIconSize = 13;
  static const double _badgeOffset = 8;
  static const double _circleToLabel = 13;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox.square(
              dimension: _circleSize,
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: AppColors.iconSurface,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      AppIcons.userProfile,
                      width: _iconSize,
                      height: _iconSize,
                    ),
                  ),
                  PositionedDirectional(
                    end: _badgeOffset,
                    bottom: _badgeOffset,
                    child: Container(
                      width: _badgeSize,
                      height: _badgeSize,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        size: _badgeIconSize,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: _circleToLabel),
            Text(label, style: AppTextStyles.sectionTitle),
          ],
        ),
      ),
    );
  }
}
