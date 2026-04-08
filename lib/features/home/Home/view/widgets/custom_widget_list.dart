import 'package:elmotamizon/features/details/models/course_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomWidgetList extends StatelessWidget {
  const CustomWidgetList({
    super.key,
    required this.list,
    required this.child,
  });

  final List<CourseModel> list;
  final Widget Function(int index) child;
  @override
  Widget build(BuildContext context) {
    final limitedList = list.take(10).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: limitedList.asMap().entries.map((entry) {
            final index = entry.key;
            return Padding(
              padding: EdgeInsetsDirectional.only(end: index != limitedList.asMap().entries.length-1 ? 10.w : 0),
              child: SizedBox(width: 150.w, child: child(index)),
            );
          }).toList(),
        ),
      ),
    );
  }
}
