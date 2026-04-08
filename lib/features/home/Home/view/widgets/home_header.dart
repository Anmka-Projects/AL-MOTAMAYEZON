import 'package:elmotamizon/app/app_prefs.dart';
import 'package:elmotamizon/app/imports.dart';
import 'package:elmotamizon/app/app_functions.dart';
import 'package:elmotamizon/common/extensions/context_extension.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/constants/assets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:elmotamizon/features/notifications/view/notifications_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${AppStrings.welcome.tr()} ${instance<AppPreferences>().getUserName()} 👋",
                  style: context.textTheme.bodyMedium!.copyWith(
                    color: Colors.black,
                    fontSize: 16.sp,
                  ),
                ),
                Gap(4.h),
                Text(
                  AppStrings.completeLearning.tr(),
                  style: context.textTheme.bodyMedium!.copyWith(
                    color: ColorManager.textGrayColor,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              AppFunctions.navigateTo(
                context,
                const NotificationsView(),
              );
            },
            icon: SvgPicture.asset(Assets.assetsIconsNotifications,height: 30.w,width: 30.w,),
          ),
        ],
      ),
    );
  }
}
