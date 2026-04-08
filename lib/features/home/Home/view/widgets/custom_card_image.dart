// ignore_for_file: deprecated_member_use

import 'package:elmotamizon/common/widgets/default_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCardImage extends StatelessWidget {
  const CustomCardImage({
    super.key,
    required this.image,
    this.height,
    this.width,
  });

  final String image;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 135.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        child: DefaultImageWidget(
          image: image,
          height: height ?? 125.h,
          width: width ?? 135.w,
          radius: 10.r,
        ),
      ),
    );
  }
}
