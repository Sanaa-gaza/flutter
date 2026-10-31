import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sanaa_app/core/constants/api_constants.dart';
import 'package:flutter_sanaa_app/core/theme/app_colors.dart';
import 'package:flutter_sanaa_app/core/theme/app_spacing.dart';
import 'package:flutter_sanaa_app/core/theme/app_text_styles.dart';
import 'package:flutter_sanaa_app/core/widgets/app_text_field.dart';

/// Phone number without the country code; the app adds it when sending.
class AppPhoneField extends StatelessWidget {
  const AppPhoneField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.textInputAction,
    this.validator,
    this.errorText,
    this.onChanged,
  });

  final String label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  static const int _localNumberLength = 9;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: label,
      hint: hint,
      trailing: const _CountryCodeChip(),
      controller: controller,
      keyboardType: TextInputType.phone,
      textInputAction: textInputAction,
      autofillHints: const [AutofillHints.telephoneNumberNational],
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(_localNumberLength),
      ],
      validator: validator,
      errorText: errorText,
      onChanged: onChanged,
    );
  }
}

class _CountryCodeChip extends StatelessWidget {
  const _CountryCodeChip();

  static const double _width = 58;
  static const double _innerRadius = 24;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _width,
      height: AppSizes.fieldHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.primaryChip,
        border: Border.all(color: AppColors.primary),
        borderRadius: const BorderRadiusDirectional.horizontal(
          start: Radius.circular(_innerRadius),
          end: Radius.circular(AppRadius.field),
        ),
      ),
      child: const Text(
        ApiConstants.phoneCountryCode,
        style: AppTextStyles.phonePrefix,
        textDirection: TextDirection.ltr,
      ),
    );
  }
}
