import 'package:flutter/material.dart';

class AppTextStyles {
  static TextStyle getRegularStyle({
    required double fontSize,
    required Color color,
  }) {
    return TextStyle(
      fontSize: fontSize,
      color: color,
      fontFamily: 'Rubik',
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle getMediumStyle({
    required double fontSize,
    required Color color,
  }) {
    return TextStyle(
      fontSize: fontSize,
      color: color,
      fontFamily: 'Rubik',
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle getSemiBoldStyle({
    required double fontSize,
    required Color color,
  }) {
    return TextStyle(
      fontSize: fontSize,
      color: color,
      fontFamily: 'Rubik',
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle getBoldStyle({
    required double fontSize,
    required Color color,
  }) {
    return TextStyle(
      fontSize: fontSize,
      color: color,
      fontFamily: 'Rubik',
      fontWeight: FontWeight.w700,
    );
  }

  // Arabic Font Styles
  static TextStyle getArabicRegularStyle({
    required double fontSize,
    required Color color,
  }) {
    return TextStyle(
      fontSize: fontSize,
      color: color,
      fontFamily: 'Rubik-Arabic',
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle getArabicMediumStyle({
    required double fontSize,
    required Color color,
  }) {
    return TextStyle(
      fontSize: fontSize,
      color: color,
      fontFamily: 'Rubik-Arabic',
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle getArabicSemiBoldStyle({
    required double fontSize,
    required Color color,
  }) {
    return TextStyle(
      fontSize: fontSize,
      color: color,
      fontFamily: 'Rubik-Arabic',
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle getArabicBoldStyle({
    required double fontSize,
    required Color color,
  }) {
    return TextStyle(
      fontSize: fontSize,
      color: color,
      fontFamily: 'Rubik-Arabic',
      fontWeight: FontWeight.w700,
    );
  }
}
