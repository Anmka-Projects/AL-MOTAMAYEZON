import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ThemeManager {
  static ThemeData getTheme() {
    return ThemeData(
      primaryColor: ColorManager.primary,
      scaffoldBackgroundColor: Colors.white,
      fontFamily: 'Rubik',
      textTheme: TextTheme(
        displayLarge: AppTextStyles.getBoldStyle(
          fontSize: 32.sp,
          color: Colors.black,
        ),
        displayMedium: AppTextStyles.getBoldStyle(
          fontSize: 28.sp,
          color: Colors.black,
        ),
        displaySmall: AppTextStyles.getBoldStyle(
          fontSize: 24.sp,
          color: Colors.black,
        ),
        headlineLarge: AppTextStyles.getSemiBoldStyle(
          fontSize: 20.sp,
          color: Colors.black,
        ),
        headlineMedium: AppTextStyles.getSemiBoldStyle(
          fontSize: 18.sp,
          color: Colors.black,
        ),
        headlineSmall: AppTextStyles.getSemiBoldStyle(
          fontSize: 16.sp,
          color: Colors.black,
        ),
        titleLarge: AppTextStyles.getMediumStyle(
          fontSize: 16.sp,
          color: Colors.black,
        ),
        titleMedium: AppTextStyles.getMediumStyle(
          fontSize: 14.sp,
          color: Colors.black,
        ),
        titleSmall: AppTextStyles.getMediumStyle(
          fontSize: 12.sp,
          color: Colors.black,
        ),
        bodyLarge: AppTextStyles.getRegularStyle(
          fontSize: 16.sp,
          color: Colors.black,
        ),
        bodyMedium: AppTextStyles.getRegularStyle(
          fontSize: 14.sp,
          color: Colors.black,
        ),
        bodySmall: AppTextStyles.getRegularStyle(
          fontSize: 12.sp,
          color: Colors.black,
        ),
      ),
      appBarTheme: AppBarTheme(
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        toolbarTextStyle: AppTextStyles.getBoldStyle(
          fontSize: 20.sp,
          color: Colors.black,
        ),
        titleTextStyle: AppTextStyles.getBoldStyle(
          fontSize: 20,
          color: Colors.black,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ColorManager.primary;
          }
          return ColorManager.lightGreyColor;
        }),
        side: const BorderSide(color: ColorManager.borderColor, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorManager.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          elevation: 0,
          textStyle: AppTextStyles.getMediumStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(
            color: ColorManager.primary,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
        hintStyle: AppTextStyles.getRegularStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
      ),
      colorScheme: const ColorScheme.light(
        primary: ColorManager.primary,
        secondary: Colors.black,
      ),
      dividerTheme: DividerThemeData(
        color: Colors.grey.shade300,
        thickness: 1,
      ),
    );
  }
}
