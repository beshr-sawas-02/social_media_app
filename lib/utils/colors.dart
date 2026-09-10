import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF6C3CE1);
  static const Color primaryDark = Color(0xFF4F2AB0);
  static const Color primarySoft = Color(0xFF8B6CFF);
  static const Color secondary = Color(0xFFFF8A3D);
  static const Color night = Color(0xFF160B2E);
  static const Color nightDeep = Color(0xFF0A0614);
  static const Color background = Color(0xFFF4F0FB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceSoft = Color(0xFFFBF9FF);
  static const Color textPrimary = Color(0xFF1C1C1E);
  static const Color textSecondary = Color(0xFF8E8E93);
  static const Color divider = Color(0xFFE8E2F3);
  static const Color white = Colors.white;
  static const Color red = Color(0xFFE53935);
  static Color gray300 = Colors.grey.shade300;
  static const Color gray = Colors.grey;
  static const Color blue = Color(0xFF1E88E5);

  // Legacy alias used in older screens
  static const Color secoundry = secondary;

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF7B4DFF), Color(0xFF5B2DE8), Color(0xFF3F1DB8)],
  );

  static const LinearGradient nightGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0A0614),
      Color(0xFF160B2E),
      Color(0xFF241045),
    ],
  );

  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: primary.withValues(alpha: 0.08),
          blurRadius: 22,
          offset: const Offset(0, 10),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.03),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];
}
