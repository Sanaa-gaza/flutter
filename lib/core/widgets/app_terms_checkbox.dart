import 'package:flutter/material.dart';
import 'package:flutter_sanaa_app/core/theme/app_colors.dart';
import 'package:flutter_sanaa_app/core/theme/app_text_styles.dart';
import 'package:flutter_sanaa_app/l10n/app_localizations.dart';

class AppTermsCheckbox extends StatelessWidget {
  const AppTermsCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.errorText,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final String? errorText;

  static const double _boxSize = 16;
  static const double _boxRadius = 4;
  static const double _checkSize = 12;
  static const double _boxToText = 10;
  static const EdgeInsets _padding = EdgeInsets.symmetric(
    horizontal: 7,
    vertical: 6,
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final error = errorText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          checked: value,
          child: InkWell(
            onTap: () => onChanged(!value),
            child: Padding(
              padding: _padding,
              child: Row(
                children: [
                  Container(
                    width: _boxSize,
                    height: _boxSize,
                    decoration: BoxDecoration(
                      color: value ? AppColors.primary : null,
                      border: Border.all(
                        color: value ? AppColors.primary : AppColors.textMuted,
                      ),
                      borderRadius: BorderRadius.circular(_boxRadius),
                    ),
                    child: value
                        ? const Icon(
                            Icons.check,
                            size: _checkSize,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  const SizedBox(width: _boxToText),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        style: AppTextStyles.terms,
                        children: [
                          TextSpan(text: l10n.termsAgree),
                          TextSpan(
                            text: l10n.termsAndConditions,
                            style: AppTextStyles.termsBold,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (error != null)
          Padding(
            padding: _padding,
            child: Text(error, style: AppTextStyles.fieldError),
          ),
      ],
    );
  }
}
