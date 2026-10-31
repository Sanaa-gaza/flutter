import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sanaa_app/core/constants/app_icons.dart';
import 'package:flutter_sanaa_app/core/widgets/app_text_field.dart';

/// Phone number without the country code; the app adds `+970` when sending.
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
      iconAsset: AppIcons.phone,
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
