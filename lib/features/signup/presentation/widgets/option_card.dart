import 'package:flutter/material.dart';
import 'package:flutter_sanaa_app/core/theme/app_colors.dart';
import 'package:flutter_sanaa_app/core/theme/app_spacing.dart';
import 'package:flutter_sanaa_app/core/theme/app_text_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A tappable card with an icon, a title and a short description.
class OptionCard extends StatelessWidget {
  const OptionCard({
    super.key,
    required this.title,
    required this.description,
    required this.iconAsset,
    required this.iconSize,
    required this.onTap,
  });

  final String title;
  final String description;
  final String iconAsset;
  final double iconSize;
  final VoidCallback onTap;

  static const double _padding = 16;
  static const double _iconBoxSize = 65;
  static const double _iconBoxRadius = 20;
  static const double _iconToText = 10;
  static const double _titleToDescription = 1;
  static const double _descriptionMinHeight = 40;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(AppRadius.card);

    return Semantics(
      button: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          boxShadow: const [
            BoxShadow(
              color: AppColors.cardShadow,
              offset: Offset(0, 2),
              blurRadius: 8,
            ),
          ],
        ),
        child: Material(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
            side: const BorderSide(color: AppColors.optionCardBorder),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(_padding),
              child: Row(
                children: [
                  Container(
                    width: _iconBoxSize,
                    height: _iconBoxSize,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.iconSurface,
                      borderRadius: BorderRadius.circular(_iconBoxRadius),
                    ),
                    child: SvgPicture.asset(
                      iconAsset,
                      width: iconSize,
                      height: iconSize,
                    ),
                  ),
                  const SizedBox(width: _iconToText),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: AppTextStyles.optionTitle),
                        const SizedBox(height: _titleToDescription),
                        ConstrainedBox(
                          constraints: const BoxConstraints(
                            minHeight: _descriptionMinHeight,
                          ),
                          child: Text(
                            description,
                            style: AppTextStyles.optionDescription,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
