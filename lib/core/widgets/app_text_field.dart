import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sanaa_app/core/theme/app_colors.dart';
import 'package:flutter_sanaa_app/core/theme/app_spacing.dart';
import 'package:flutter_sanaa_app/core/theme/app_text_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.iconAsset,
    this.trailing,
    this.onIconTap,
    this.iconSemanticLabel,
    this.obscureText = false,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.inputFormatters,
    this.validator,
    this.errorText,
    this.onChanged,
  });

  final String label;
  final String? hint;
  final String? iconAsset;

  /// Shown at the end of the field instead of [iconAsset].
  final Widget? trailing;

  /// Makes the icon tappable, e.g. to show or hide a password.
  final VoidCallback? onIconTap;
  final String? iconSemanticLabel;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String>? validator;

  /// An error returned by the server for this field, shown under it.
  final String? errorText;
  final ValueChanged<String>? onChanged;

  static const double _iconSize = 16;
  static const double _iconTapRadius = 20;
  static const double _horizontalPadding = 11;
  static const double _verticalPadding = 9;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: AppTextStyles.fieldLabel),
        const SizedBox(height: AppSpacing.labelToField),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          autofillHints: autofillHints,
          inputFormatters: inputFormatters,
          validator: validator,
          onChanged: onChanged,
          obscureText: obscureText,
          // Stops the keyboard from learning and suggesting secret input.
          autocorrect: !obscureText,
          enableSuggestions: !obscureText,
          style: AppTextStyles.fieldInput,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.fieldHint,
            errorText: errorText,
            errorStyle: AppTextStyles.fieldError,
            errorMaxLines: 2,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: _horizontalPadding,
              vertical: _verticalPadding,
            ),
            suffixIcon: _buildIcon(),
            suffixIconConstraints: const BoxConstraints(
              minWidth: _iconSize + _horizontalPadding,
              minHeight: _iconSize,
            ),
            enabledBorder: _border(AppColors.primary),
            focusedBorder: _border(AppColors.primary, width: 1.5),
            errorBorder: _border(AppColors.error),
            focusedErrorBorder: _border(AppColors.error, width: 1.5),
          ),
        ),
      ],
    );
  }

  Widget? _buildIcon() {
    if (trailing != null) return trailing;

    final asset = iconAsset;
    if (asset == null) return null;

    final icon = SvgPicture.asset(
      asset,
      width: _iconSize,
      height: _iconSize,
      semanticsLabel: iconSemanticLabel,
    );

    return Padding(
      padding: const EdgeInsetsDirectional.only(end: _horizontalPadding),
      child: onIconTap == null
          ? icon
          : InkResponse(
              onTap: onIconTap,
              radius: _iconTapRadius,
              child: icon,
            ),
    );
  }

  static OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.field),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
