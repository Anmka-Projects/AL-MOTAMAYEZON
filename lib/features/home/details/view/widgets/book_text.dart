import 'package:elmotamizon/common/extensions/context_extension.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class BookText extends StatelessWidget {
  const BookText({
    super.key,
    required this.text,
    required this.havePerfix,
    required this.havePostfix,
    required this.perfixIcon,
    required this.postfixIcon,
    this.color,
    this.time,
    this.haveTime,
    this.postfixOnTap,
  });
  final String text;
  final bool havePerfix;
  final bool havePostfix;
  final String perfixIcon;

  final String postfixIcon;
  final Color? color;
  final String? time;
  final bool? haveTime;
  final void Function()? postfixOnTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        havePerfix
            ? Container(
                padding: EdgeInsets.all(5.r),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: ColorManager.grayColor2,
                ),
                child: SvgPicture.asset(
                  perfixIcon,
                  //Assets.assetsIconsDownload,
                  width: 15.w,
                  height: 15.h,
                ),
              )
            : const SizedBox.shrink(),
        Gap(5.w),
        Expanded(
          child: Text(
            text,
            style: context.textTheme.bodyMedium!.copyWith(
              color: color ?? ColorManager.textGrayColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // const Spacer(),
        (haveTime ?? false)
            ? Text(
                time ?? "",
                style: context.textTheme.bodyMedium!.copyWith(
                  color: ColorManager.grayColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )
            : const SizedBox.shrink(),
        const Gap(5),
        havePostfix
            ? GestureDetector(
                onTap: postfixOnTap,
                child: SvgPicture.asset(
                  postfixIcon,
                  //Assets.assetsIconsDownload,
                  width: 15.w,
                  height: 15.h,
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
