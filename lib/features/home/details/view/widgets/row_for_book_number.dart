import 'package:elmotamizon/common/resources/assets_manager.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/constants/assets.dart';
import 'package:elmotamizon/features/home/details/view/details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class RowForBookNumber extends StatelessWidget {
  const RowForBookNumber({
    super.key,
    required this.filesCount,
    required this.lessonsCount,
    required this.voiceCount,
  });
  final int filesCount, lessonsCount, voiceCount;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 1.w,
        children: [
          // const Spacer(),
          SvgPicture.asset(
            IconAssets.subject,
            width: 20.w,
            height: 20.h,
            color: ColorManager.grey,
          ),
          TextItem(text: " $filesCount كتب"),
          Gap(10.w),
          const VerticalDivider(),
          Gap(10.w),
          SvgPicture.asset(
            Assets.assetsIconsCourse,
            width: 20.w,
            height: 20.h,
          ),
          TextItem(text: " $lessonsCount محاضره"),
          Gap(10.w),
          const VerticalDivider(),
          Gap(10.w),
          SvgPicture.asset(
            Assets.assetsIconsVoice,
            width: 20.w,
            height: 20.h,
          ),
          TextItem(text: " $voiceCount فويس نوت"),
          // const Spacer(),
        ],
      ),
    );
  }
}
