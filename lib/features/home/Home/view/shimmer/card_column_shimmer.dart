import 'package:elmotamizon/common/widgets/shimmer_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CardColumnShimmer extends StatelessWidget {
  const CardColumnShimmer({super.key, this.width, this.height});
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShimmerContainerWidget(
          height: height ?? 125.h,
        ),
        Gap(15.h),
        const ShimmerContainerWidget(
          height: 20,
        ),
        Gap(5.h),
        const Padding(
          padding: EdgeInsetsDirectional.only(end: 30),
          child: ShimmerContainerWidget(
            height: 20,
          ),
        ),
      ],
    );
  }
}
