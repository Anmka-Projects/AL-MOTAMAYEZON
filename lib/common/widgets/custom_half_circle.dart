// ignore_for_file: deprecated_member_use

import 'package:elmotamizon/common/extensions/context_extension.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:flutter/material.dart';

class CustomHalfCircle extends StatelessWidget {
  const CustomHalfCircle({super.key});

  @override
  Widget build(BuildContext context) {
    final height = context.screenWidth / 2;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // نصف دائرة كبيرة
        Container(
          width: context.screenWidth,
          height: height,
          decoration: BoxDecoration(
            color: ColorManager.primary.withOpacity(0.6), // لون الوردي الفاتح
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(300)),
          ),
        ),
        // نصف دائرة متوسطة
        Container(
          width: context.screenWidth * 0.8,
          height: height * 0.8,
          decoration: BoxDecoration(
            color: ColorManager.primary.withOpacity(0.8), // لون أغمق
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(250)),
          ),
        ),
        // نصف دائرة صغيرة
        Container(
          width: context.screenWidth * 0.6,
          height: height * 0.6,
          decoration: const BoxDecoration(
            color: ColorManager.primary, // لون غامق
            borderRadius: BorderRadius.vertical(top: Radius.circular(200)),
          ),
        ),
      ],
    );
  }
}
