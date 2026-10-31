import 'package:flutter/material.dart';
import 'package:flutter_sanaa_app/core/widgets/app_text_field.dart';

class AppMultilineField extends StatelessWidget {
  const AppMultilineField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.validator,
    this.errorText,
    this.onChanged,
  });

  final String label;
  final String? hint;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  static const int _visibleLines = 5;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: label,
      hint: hint,
      lines: _visibleLines,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      controller: controller,
      validator: validator,
      errorText: errorText,
      onChanged: onChanged,
    );
  }
}
