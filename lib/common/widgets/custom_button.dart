// ignore_for_file: deprecated_member_use

import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isLoading;
  final Color? backgroundColor;
  final double? width, height;
  final Color? textColor;
  final double? radius;
  final Color? borderSideColor;
  final bool? hasButton;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.backgroundColor,
    this.width,
    this.height,
    this.textColor,
    this.radius,
    this.borderSideColor,
    this.hasButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 56.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? ColorManager.primary,
          foregroundColor: Colors.white,
          side: borderSideColor == null
              ? null
              : BorderSide(color: borderSideColor!),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 12.r),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: ColorManager.primary,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: hasButton ?? false
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.center,
                spacing: hasButton ?? false ? 20.w : 0,
                children: [
                  hasButton ?? false
                      ? Row(
                          children: [
                            Gap(30.w),
                            Container(
                              width: 40.w,
                              height: 40.w,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.4),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.location_on_outlined,
                                  size: 25.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                  Flexible(
                    child: Center(
                      child: Text(
                        text,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: textColor ?? Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
