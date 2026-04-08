// ignore_for_file: deprecated_member_use

import 'package:elmotamizon/common/extensions/context_extension.dart';
import 'package:elmotamizon/constants/assets.dart';
import 'package:elmotamizon/features/home/Home/view/widgets/custom_card_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class DetailsImagePlayVideo extends StatelessWidget {
  const DetailsImagePlayVideo({
    super.key,
    required this.image,
  });
  final String image;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomCardImage(
          width: context.screenWidth,
          height: 200.h,
          image: image,
          //"https://almutamayizun.besohola.com/uploads/courses//1757847448_68c69f98cce51_about_2.jpg",
        ),
        Container(
          padding: EdgeInsets.all(15.r),
          height: 80.h,
          width: 80.w,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25),
            borderRadius: BorderRadius.circular(50.r),
          ),
          child: Container(
            padding: EdgeInsets.all(10.r),
            height: 60.h,
            width: 60.w,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.35),
              borderRadius: BorderRadius.circular(50.r),
            ),
            child: Align(
              alignment: Alignment.center,
              child: SvgPicture.asset(
                Assets.assetsIconsPlayWhite,
                height: 25.h,
                width: 25.w,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
