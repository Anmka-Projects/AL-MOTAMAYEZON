import 'package:elmotamizon/common/resources/assets_manager.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/styles_manager.dart';
import 'package:elmotamizon/common/widgets/default_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HeaderImageWidget extends StatelessWidget {
  final String image;
  final String name;
  final void Function()? onClose;
  const HeaderImageWidget({super.key, required this.image, required this.name, this.onClose});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DefaultImageWidget(image: image,height: MediaQuery.sizeOf(context).height*.3,),
        PositionedDirectional(
          top: 70.h,
          end: 30.w,
          child: InkWell(
            onTap: onClose ?? () => Navigator.pop(context),
            child: CircleAvatar(
              backgroundColor: ColorManager.white,
              radius: 13.r,
              child: SvgPicture.asset(IconAssets.close),
            ),
          ),
        ),
        PositionedDirectional(
            bottom: 15.h,
            start: 30.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: ColorManager.blackText,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                name,
                style: getBoldStyle(fontSize: 14.sp, color: ColorManager.white),
                textAlign: TextAlign.start,

              ),
            )),
      ],
    );
  }
}
