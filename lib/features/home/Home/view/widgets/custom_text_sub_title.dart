// ignore_for_file: deprecated_member_use

import 'package:elmotamizon/common/extensions/context_extension.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextSubTitle extends StatelessWidget {
  const CustomTextSubTitle({
    super.key,
    required this.subTitle,
  });

  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Text(
      subTitle,
      style: getBoldStyle(
        color: ColorManager.textGrayColor,
        fontSize: 12.sp,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
