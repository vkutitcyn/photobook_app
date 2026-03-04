import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF19C5D1);
  static const primaryPressed = Color(0xFF16AEB8);
  static const background = Color(0xFFFFFFFF);
  static const surface = Color(0xFFF6F6F6);
  static const textPrimary1 = Color(0xFF141414);
  static const textPrimary2 = Color(0xFF55B0B6);
  static const textSecondary1 = Color(0xFFFFFFFF);
  static const textSecondary2 = Color(0xFF9B9B9B);
  static const divider = Color(0xFF979797);
  static const heroOverlay = Color(0xFF000000);
}

class AppTextStyles {
  static const heroTitle = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary1,
  );

  static const heroAccent = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  static const heroSubtitle = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary1,
  );

  static const sectionTitle = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary1,
  );

  static const body = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary1,
  );

  static const cardTitle = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary1,
  );

  static const price = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary2,
  );

  static const oldPrice = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 8,
    fontWeight: FontWeight.w400,
    decoration: TextDecoration.lineThrough,
    color: AppColors.textSecondary2,
  );

  static const date = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary1,
  );

  static const location = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 8,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary2,
  );

  static const buttonText = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary1,
  );

  static const tabLabel = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 8,
    fontWeight: FontWeight.w500,
  );
}

class AppRadius {
  static const small = 4.0;
  static const button = 16.0;
  static const card = 16.0;
  static const bottomSheet = 47.0;
}

class AppSpacing {
  static const horizontal = 16.0;
  static const sectionGap = 32.0;
  static const xs = 8.0;
  static const s = 16.0;
  static const m = 32.0;
}
