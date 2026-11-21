import 'package:flutter/material.dart';
import 'package:flutter_sanaa_app/core/constants/app_icons.dart';
import 'package:flutter_sanaa_app/core/theme/app_text_styles.dart';
import 'package:flutter_sanaa_app/l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppTopBar extends StatelessWidget {
  const AppTopBar({super.key, this.title, this.onBack});

  final String? title;

  /// Passing null hides the back arrow, e.g. on the first screen of a flow.
  final VoidCallback? onBack;

  static const double _arrowSize = 32;
  static const double _arrowTapRadius = 24;

  @override
  Widget build(BuildContext context) {
    final titleText = title;
    final back = onBack;

    return SizedBox(
      height: _arrowSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (titleText != null)
            Text(titleText, style: AppTextStyles.topBarTitle),
          if (back != null)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Semantics(
                button: true,
                label: AppLocalizations.of(context).backButton,
                child: InkResponse(
                  onTap: back,
                  radius: _arrowTapRadius,
                  child: SvgPicture.asset(
                    AppIcons.arrowBack,
                    width: _arrowSize,
                    height: _arrowSize,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
