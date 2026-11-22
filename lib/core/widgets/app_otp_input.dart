import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sanaa_app/core/theme/app_colors.dart';
import 'package:flutter_sanaa_app/core/theme/app_spacing.dart';
import 'package:flutter_sanaa_app/core/theme/app_text_styles.dart';

/// Six digit boxes backed by one hidden text field, so typing, deleting and
/// pasting a whole code all behave like a normal field.
///
/// The screen owns [controller] and [focusNode] so it can clear the code and
/// focus the first box again after a wrong code.
class AppOtpInput extends StatelessWidget {
  const AppOtpInput({
    super.key,
    required this.label,
    required this.controller,
    required this.focusNode,
    this.onCompleted,
    this.errorText,
  });

  final String label;
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String>? onCompleted;
  final String? errorText;

  static const int length = 6;
  static const double _boxWidth = 45;
  static const double _boxHeight = 48;
  static const double _boxGap = 10;
  static const double _labelToBoxes = 20;

  @override
  Widget build(BuildContext context) {
    final error = errorText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: AppTextStyles.fieldLabel),
        const SizedBox(height: _labelToBoxes),
        LayoutBuilder(
          builder: (context, constraints) {
            final boxWidth = math.min(
              _boxWidth,
              (constraints.maxWidth - _boxGap * (length - 1)) / length,
            );
            return SizedBox(
              height: _boxHeight,
              child: Stack(
                children: [
                  ListenableBuilder(
                    listenable: Listenable.merge([controller, focusNode]),
                    builder: (context, _) => _buildBoxes(boxWidth),
                  ),
                  Positioned.fill(child: _buildHiddenField()),
                ],
              ),
            );
          },
        ),
        if (error != null) ...[
          const SizedBox(height: AppSpacing.labelToField),
          Text(error, style: AppTextStyles.fieldError),
        ],
      ],
    );
  }

  Widget _buildBoxes(double boxWidth) {
    final code = controller.text;
    final hasError = errorText != null;

    // Codes are read left to right even inside the Arabic layout.
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var index = 0; index < length; index++) ...[
            if (index > 0) const SizedBox(width: _boxGap),
            _OtpBox(
              width: boxWidth,
              height: _boxHeight,
              digit: index < code.length ? code[index] : '',
              isActive: focusNode.hasFocus &&
                  index == math.min(code.length, length - 1),
              hasError: hasError,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHiddenField() {
    return Opacity(
      opacity: 0,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        autofillHints: const [AutofillHints.oneTimeCode],
        // Stops the keyboard from learning the code.
        autocorrect: false,
        enableSuggestions: false,
        showCursor: false,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(length),
        ],
        decoration: const InputDecoration.collapsed(hintText: null),
        onChanged: (value) {
          if (value.length == length) onCompleted?.call(value);
        },
      ),
    );
  }
}

class _OtpBox extends StatelessWidget {
  const _OtpBox({
    required this.width,
    required this.height,
    required this.digit,
    required this.isActive,
    required this.hasError,
  });

  final double width;
  final double height;
  final String digit;
  final bool isActive;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.field),
        border: Border.all(
          color: hasError ? AppColors.error : AppColors.primary,
          width: isActive ? 1.5 : 1,
        ),
      ),
      child: Text(digit, style: AppTextStyles.otpDigit),
    );
  }
}
