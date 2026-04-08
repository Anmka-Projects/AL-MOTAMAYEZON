import 'package:elmotamizon/common/extensions/context_extension.dart';
import 'package:elmotamizon/common/widgets/shimmer_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CardRowShimmer extends StatelessWidget {
  const CardRowShimmer({super.key, this.width, this.height});
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerContainerWidget(
          height: height ?? 125.h,
          width: width ?? 100.h,
        ),
        Gap(15.h),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ShimmerContainerWidget(
                height: 20,
                // width: context.screenWidth * 0.8,
              ),
              Gap(5.h),
              const Padding(
                padding: EdgeInsetsDirectional.only(end: 30),
                child: ShimmerContainerWidget(
                  height: 20,
                  // width: context.screenWidth * 0.8,
                ),
              ),
              Gap(5.h),
              const Padding(
                padding: EdgeInsetsDirectional.only(end: 40),
                child: ShimmerContainerWidget(
                  height: 20,
                  // width: context.screenWidth * 0.8,
                ),
              ),
              Gap(5.h),
              const Padding(
                padding: EdgeInsetsDirectional.only(end: 50),
                child: ShimmerContainerWidget(
                  height: 20,
                  // width: context.screenWidth * 0.8,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
