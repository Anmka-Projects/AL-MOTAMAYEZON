import 'package:elmotamizon/common/resources/assets_manager.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final bool withLeading;
  final Color? backgroundColor;
  final Color? titleColor;
  final List<Widget>? actions;
  const DefaultAppBar(
      {super.key,
      required this.text,
      this.withLeading = true,
      this.backgroundColor,
      this.titleColor,
      this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(
          color: titleColor ?? ColorManager.blackText, size: 30.r),
      backgroundColor: backgroundColor,
      title: Text(
        text,
        style: getBoldStyle(
            fontSize: 20.sp, color: titleColor ?? ColorManager.blackText),
      ),
      centerTitle: true,
      leading: withLeading ? null : const SizedBox.shrink(),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(50.h);
}
