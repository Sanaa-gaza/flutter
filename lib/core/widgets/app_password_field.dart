import 'package:flutter/material.dart';
import 'package:flutter_sanaa_app/core/constants/app_icons.dart';
import 'package:flutter_sanaa_app/core/widgets/app_text_field.dart';
import 'package:flutter_sanaa_app/l10n/app_localizations.dart';

class AppPasswordField extends StatefulWidget {
  const AppPasswordField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.textInputAction,
    this.autofillHints,
    this.validator,
    this.errorText,
    this.onChanged,
  });

  final String label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final FormFieldValidator<String>? validator;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  bool _isHidden = true;

  void _toggleVisibility() => setState(() => _isHidden = !_isHidden);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppTextField(
      label: widget.label,
      hint: widget.hint,
      controller: widget.controller,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: widget.textInputAction,
      autofillHints: widget.autofillHints,
      validator: widget.validator,
      errorText: widget.errorText,
      onChanged: widget.onChanged,
      obscureText: _isHidden,
      iconAsset: _isHidden ? AppIcons.eyeOpen : AppIcons.eyeClosed,
      iconSemanticLabel: _isHidden ? l10n.showPassword : l10n.hidePassword,
      onIconTap: _toggleVisibility,
    );
  }
}
