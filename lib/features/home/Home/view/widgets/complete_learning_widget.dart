import 'package:easy_localization/easy_localization.dart';
import 'package:elmotamizon/common/extensions/context_extension.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/language_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/common/widgets/default_image_widget.dart';
import 'package:elmotamizon/features/details/models/course_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class CompleteLearningWidget extends StatelessWidget {
  final CourseModel course;
  const CompleteLearningWidget({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: ColorManager.borderTextColor,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          DefaultImageWidget(
            image: course.image ?? "",
            height: 100.h,
            width: 100.w,
            onTap: () {},
            radius: 10.r,
          ),
          Gap(10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 7.h,
              children: [
                Text(
                  course.name ?? "",
                  style: context.textTheme.bodyMedium!.copyWith(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  course.description ?? "",
                  style: context.textTheme.bodyMedium!.copyWith(
                    color: ColorManager.primary,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // RateWidget(
                //   rate: (course.rate ?? 0).toString(),
                // ),
                LinearPercentIndicator(
                  padding: EdgeInsets.zero,
                  isRTL: language == "ar",
                  animation: true,
                  lineHeight: 10.0,
                  animationDuration: 2000,
                  percent: (((course.progress?.percent) ?? 0) / 100).toDouble(),
                  progressColor: ColorManager.primary,
                  backgroundColor: ColorManager.borderTextColor,
                  barRadius: Radius.circular(20.r),
                ),
                Text(
                  "${AppStrings.complete.tr()} ${((course.progress?.percent) ?? 0).toDouble()}%",
                  style: context.textTheme.bodyMedium!.copyWith(
                    color: ColorManager.textGrayColor,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
