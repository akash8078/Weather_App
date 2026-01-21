import 'package:flutter/material.dart';

class AppConstants {
  // App Info
  static const String appName = 'Glasscast';
  static const String appVersion = '1.0.0';

  // Padding & Spacing
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;

  // Border Radius
  static const double radiusS = 8.0;
  static const double radiusM = 16.0;
  static const double radiusL = 24.0;
  static const double radiusXL = 32.0;

  // Glass Effect
  static const double glassBlur = 10.0;
  static const double glassOpacity = 0.1;
  static const double glassBorderOpacity = 0.2;

  // Animation Duration
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // Weather Icons Mapping
  static const Map<String, IconData> weatherIcons = {
    'Clear': Icons.wb_sunny,
    'Clouds': Icons.cloud,
    'Rain': Icons.umbrella,
    'Drizzle': Icons.grain,
    'Thunderstorm': Icons.flash_on,
    'Snow': Icons.ac_unit,
    'Mist': Icons.blur_on,
    'Smoke': Icons.blur_on,
    'Haze': Icons.blur_on,
    'Dust': Icons.blur_on,
    'Fog': Icons.blur_on,
    'Sand': Icons.blur_on,
    'Ash': Icons.blur_on,
    'Squall': Icons.air,
    'Tornado': Icons.tornado,
  };

  // Gradients
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1E3A8A),
      Color(0xFF3B82F6),
      Color(0xFF60A5FA),
    ],
  );

  static const LinearGradient darkBackgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0F172A),
      Color(0xFF1E293B),
      Color(0xFF334155),
    ],
  );
}