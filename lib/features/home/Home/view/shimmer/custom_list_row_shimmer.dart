import 'package:elmotamizon/features/home/Home/view/shimmer/card_column_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomListRowShimmer extends StatelessWidget {
  const CustomListRowShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List list = [1, 2, 3, 4];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: IntrinsicHeight(
        child: Row(
          children: list.asMap().entries.map((entry) {
            final index = entry.key;
            return Padding(
              padding: EdgeInsetsDirectional.only(
                  end: index != list.asMap().entries.length - 1 ? 10.w : 0),
              child: SizedBox(width: 150.w, child: const CardColumnShimmer()),
            );
          }).toList(),
        ),
      ),
    );
  }
}
