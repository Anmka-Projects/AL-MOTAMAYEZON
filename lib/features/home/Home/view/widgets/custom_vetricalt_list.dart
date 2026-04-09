import 'package:elmotamizon/app/app_functions.dart';
import 'package:elmotamizon/features/details/models/course_details_model.dart';
import 'package:elmotamizon/features/home/details/view/details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CustomVetricalList extends StatelessWidget {
  const CustomVetricalList({
    super.key,
    required this.list,
    required this.child,
    this.isDetails,
  });

  final List<CourseModel> list;
  final Widget Function(int index) child;
  final bool? isDetails;

  @override
  Widget build(BuildContext context) {
    final itemCount = (list.length / 2).ceil();

    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.only(bottom: 24.h),
      itemCount: itemCount,
      itemBuilder: (context, i) {
        final index = i * 2;

        return Padding(
          padding: EdgeInsetsDirectional.only(
            start: 15.w,
            end: 15.w,
            bottom: 15.h,
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: (isDetails ?? true)
                        ? () => AppFunctions.navigateTo(
                              context,
                              Details(id: "${list[index].id}"),
                            )
                        : () {},
                    child: child(index),
                  ),
                ),
                Gap(15.w),
                if (index + 1 < list.length)
                  Expanded(
                    child: GestureDetector(
                      onTap: (isDetails ?? true)
                          ? () => AppFunctions.navigateTo(
                                context,
                                Details(id: "${list[index + 1].id}"),
                              )
                          : () {},
                      child: child(index + 1),
                    ),
                  )
                else
                  const Expanded(child: SizedBox.shrink()),
              ],
            ),
          ),
        );
      },
    );
  }
}
