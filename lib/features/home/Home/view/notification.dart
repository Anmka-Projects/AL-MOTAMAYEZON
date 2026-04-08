// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:elmotamizon/common/extensions/context_extension.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/constants/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List notifications = [
      {
        "title": "اضاف د / عمر محاضره جديده",
        "subtitle": "محاضرة جديدة تمت إضافتها: “القصد الجنائي – الجزء الثاني”.",
        "time": "الان",
      },
      {
        "title": "ملزمة جديدة",
        "subtitle": "تم رفع ملزمة جديدة: “مراجعة ما قبل الامتحان”.",
        "time": "منذ 7 دقائق",
      },
      {
        "title": "تعديل ملف",
        "subtitle": "تم تعديل ملف “أركان الجريمة.pdf” بإصدار محدث.",
        "time": "منذ 6 ساعات",
      },
      {
        "title": "اشعارات النظام",
        "subtitle": "تم عمل تحديث للتطبيق",
        "time": "15 مايو 2025  12:20 م",
      },
    ];
    return Scaffold(
        appBar: AppBar(
          title: Text(
            AppStrings.notifications.tr(),
            style: context.textTheme.displaySmall,
          ),
          centerTitle: true,
        ),
        body: notifications.isEmpty
            ? const NotificationEmptyWidget()
            : ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsetsDirectional.only(bottom: 20.h),
                    child: NotificationItem(
                      notifications: notifications[index],
                    ),
                  );
                },
              ));
  }
}

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    super.key,
    required this.notifications,
  });

  final Map<String, dynamic> notifications;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: ColorManager.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(50.r),
            ),
            child: SvgPicture.asset(
              Assets.assetsIconsNotifcation,
            ),
          ),
          Gap(10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        notifications['title'],
                        style: context.textTheme.headlineMedium!.copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: AlignmentDirectional.topEnd,
                        child: Text(
                          notifications['time'],
                          style: context.textTheme.headlineMedium!.copyWith(
                            color: ColorManager.borderColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Gap(10.w),
                Text(
                  notifications['subtitle'],
                  style: context.textTheme.headlineMedium!.copyWith(
                    color: ColorManager.textGrayColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
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

class NotificationEmptyWidget extends StatelessWidget {
  const NotificationEmptyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Gap(40.h),
            Image.asset(Assets.assetsImagesNotificationEmpty),
            Gap(20.h),
            Text(
              AppStrings.noNotifications.tr(),
              style: context.textTheme.displaySmall,
            ),
            Gap(20.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                AppStrings.registerYourCourses.tr(),
                style: context.textTheme.headlineMedium!.copyWith(
                  color: ColorManager.textGrayColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Gap(20.h),
          ],
        ),
      ),
    );
  }
}
