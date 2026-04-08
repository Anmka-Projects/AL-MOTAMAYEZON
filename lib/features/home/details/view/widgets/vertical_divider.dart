import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:flutter/material.dart';

class VerticalDivider extends StatelessWidget {
  const VerticalDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorManager.borderColor,
      height: 12,
      width: 1,
    );
  }
}
