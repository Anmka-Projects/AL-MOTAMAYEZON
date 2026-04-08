import 'package:elmotamizon/common/widgets/shimmer_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserShimmerWidget extends StatefulWidget {
  const UserShimmerWidget({super.key});

  @override
  State<UserShimmerWidget> createState() => _UserShimmerWidgetState();
}

class _UserShimmerWidgetState extends State<UserShimmerWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ShimmerContainerWidget(
            height: MediaQuery.sizeOf(context).height * .15,
            width: double.infinity,
          ),
          SizedBox(height: 10.h),
          ShimmerContainerWidget(
            height: 20.h,
            width: 100.w,
          ),
          SizedBox(
            height: 5.h,
          ),
          ShimmerContainerWidget(
            height: 20.h,
            width: 80.w,
          ),
        ],
      ),
    );
  }
}
