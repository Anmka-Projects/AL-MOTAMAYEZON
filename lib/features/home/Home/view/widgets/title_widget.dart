import 'package:easy_localization/easy_localization.dart';
import 'package:elmotamizon/common/extensions/context_extension.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  final void Function()? onTap;
  const TitleWidget({
    super.key,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Text(
            title,
            style: context.textTheme.headlineLarge,
          ),
          const Spacer(),
          Text(
            AppStrings.showAll.tr(),
            style: context.textTheme.bodyMedium!.copyWith(
              color: ColorManager.textGrayColor,
              decoration: TextDecoration.underline, //  الخط تحت النص
              decorationColor: ColorManager.textGrayColor,
              decorationThickness: 2,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}
