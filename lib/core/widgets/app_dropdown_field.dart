import 'package:flutter/material.dart';
import 'package:flutter_sanaa_app/core/constants/app_icons.dart';
import 'package:flutter_sanaa_app/core/theme/app_colors.dart';
import 'package:flutter_sanaa_app/core/theme/app_spacing.dart';
import 'package:flutter_sanaa_app/core/theme/app_text_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppDropdownField<T> extends StatelessWidget {
  const AppDropdownField({
    super.key,
    required this.label,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.hint,
    this.value,
    this.validator,
    this.errorText,
  });

  final String label;
  final List<T> items;
  final String Function(T item) itemLabel;

  /// Passing null disables the field, e.g. areas before a governorate is chosen.
  final ValueChanged<T?>? onChanged;
  final String? hint;
  final T? value;
  final FormFieldValidator<T>? validator;

  /// An error returned by the server for this field, shown under it.
  final String? errorText;

  static const double _iconSize = 16;
  static const double _horizontalPadding = 11;

  // A dense dropdown always reserves a 24px line, so 6.5px above and below
  // gives the same 37px height as the text fields.
  static const double _verticalPadding = 6.5;

  @override
  Widget build(BuildContext context) {
    final hintText = hint;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: AppTextStyles.fieldLabel),
        const SizedBox(height: AppSpacing.labelToField),
        DropdownButtonFormField<T>(
          // Rebuilds the field when the parent changes the value from outside.
          key: ValueKey(value),
          initialValue: value,
          isExpanded: true,
          isDense: true,
          style: AppTextStyles.fieldInput,
          validator: validator,
          onChanged: onChanged,
          hint: hintText == null
              ? null
              : Text(hintText, style: AppTextStyles.fieldHint),
          // The dropdown stretches its icon to iconSize, and that also sets the
          // field height, so it has to match the size used by the text fields.
          iconSize: _iconSize,
          icon: SvgPicture.asset(
            AppIcons.chevronDown,
            width: _iconSize,
            height: _iconSize,
          ),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.field),
          items: [
            for (final item in items)
              DropdownMenuItem<T>(value: item, child: Text(itemLabel(item))),
          ],
          decoration: InputDecoration(
            errorText: errorText,
            errorStyle: AppTextStyles.fieldError,
            errorMaxLines: 2,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: _horizontalPadding,
              vertical: _verticalPadding,
            ),
            // Setting border is what makes the dropdown leave a margin after
            // the icon; without it the icon touches the field edge.
            border: _border(AppColors.primary),
            enabledBorder: _border(AppColors.primary),
            focusedBorder: _border(AppColors.primary, width: 1.5),
            disabledBorder: _border(AppColors.primaryLight),
            errorBorder: _border(AppColors.error),
            focusedErrorBorder: _border(AppColors.error, width: 1.5),
          ),
        ),
      ],
    );
  }

  static OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.field),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
