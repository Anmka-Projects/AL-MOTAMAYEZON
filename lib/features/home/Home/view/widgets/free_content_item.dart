// ignore_for_file: deprecated_member_use

import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/constants/assets.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:elmotamizon/features/details/models/course_details_model.dart';
import 'package:elmotamizon/features/home/Home/view/widgets/custom_card_image.dart';
import 'package:elmotamizon/features/home/Home/view/widgets/custom_text_sub_title.dart';
import 'package:elmotamizon/features/home/Home/view/widgets/custom_text_title.dart';
import 'package:elmotamizon/features/lesson_details/models/lesson_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class FreeContentItem extends StatelessWidget {
  const FreeContentItem({
    super.key,
    required this.freeContent,
    this.width,
  });

  final CourseModel freeContent;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10.h,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            CustomCardImage(width: width, image: freeContent.image ?? ""),
            Container(
              padding: EdgeInsets.all(10.r),
              height: 50.h,
              width: 50.w,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Align(
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  Assets.assetsIconsPlay,
                  height: 25.h,
                  width: 25.w,
                ),
              ),
            ),
          ],
        ),
        CustomTextTitle(title: freeContent.name ?? "",),
        CustomTextSubTitle(subTitle: freeContent.teacher ?? "",),
        // Row(
        //   children: [
        //     Icon(
        //       Icons.remove_red_eye_outlined,
        //       color: ColorManager.primary,
        //       size: 20.sp,
        //     ),
        //     Gap(5.w),
        //     Expanded(
        //       child: CustomTextTitle(
        //           title: "${freeContent.numberOfViews} ${AppStrings.view.tr()}",
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}
