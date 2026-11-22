import 'package:flutter/painting.dart';

abstract final class AppColors {
  static const Color primary = Color(0xFF4B9AD2);
  static const Color primaryLight = Color(0xFF8EC0E4);
  static const Color primarySurface = Color(0xFFEAF3FB);
  static const Color primaryChip = Color(0x334B9AD2);
  static const Color primaryDarker = Color(0xFF1A364A);
  static const Color darkNavy = Color(0xFF22455E);

  static const Color textPrimary = Color(0xFF141415);
  static const Color textBody = Color(0xFF414141);
  static const Color textSecondary = Color(0xFF575757);
  static const Color textHint = Color(0xFF89949D);
  static const Color textMuted = Color(0xFF919191);
  static const Color textUpload = Color(0xFF646867);

  static const Color background = Color(0xFFF9F9FC);
  static const Color cardBorder = Color(0xFFF4F4F4);
  static const Color stepInactive = Color(0xFFCFD0D0);
  static const Color stepInactiveLine = Color(0xFFDDDDDD);

  static const Color error = Color(0xFFD64545);
  static const Color errorSurface = Color(0x14D64545);
  static const Color success = Color(0xFF2EAF4E);

  static const Color gradientStart = Color(0xFF1383C6);
  static const Color gradientEnd = Color(0xCC1591DC);

  static const LinearGradient primaryButtonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [gradientStart, gradientEnd],
  );
}
