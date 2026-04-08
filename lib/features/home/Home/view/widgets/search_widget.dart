import 'package:elmotamizon/app/app_functions.dart';
import 'package:elmotamizon/common/base/courses_type.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/constants/assets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:elmotamizon/features/home/Home/view/widgets/show_all.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: GestureDetector(
        onTap: () {
          AppFunctions.navigateTo(
              context,
              ShowAll(
                text: AppStrings.searchText.tr(),
                type: CoursesType.search,
              ));
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: ColorManager.borderTextColor),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            spacing: 10.w,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: SvgPicture.asset(
                  Assets.assetsIconsNewSearch,
                  width: 20.w,
                  height: 20.h,
                ),
              ),
              Text(
                AppStrings.search.tr(),
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
