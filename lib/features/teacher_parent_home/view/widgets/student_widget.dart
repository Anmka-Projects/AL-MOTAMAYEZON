import 'package:elmotamizon/app/app_functions.dart';
import 'package:elmotamizon/app/app_prefs.dart';
import 'package:elmotamizon/app/imports.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/common/resources/styles_manager.dart';
import 'package:elmotamizon/common/widgets/default_button_widget.dart';
import 'package:elmotamizon/common/widgets/default_image_widget.dart';
import 'package:elmotamizon/features/details/view/details_view.dart';
import 'package:elmotamizon/features/teacher_parent_home/models/students_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentWidget extends StatefulWidget {
  final StudentModel student;
  const StudentWidget({super.key, required this.student});

  @override
  State<StudentWidget> createState() => _StudentWidgetState();
}

class _StudentWidgetState extends State<StudentWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        AppFunctions.navigateTo(context, DetailsView(id: widget.student.studentId??0,detailsType: DetailsType.student,student: widget.student,));
      },
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        padding: EdgeInsets.only(bottom: 10.h),
        width: 150.w,
        decoration: BoxDecoration(
            color: ColorManager.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: ColorManager.greyBorder),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _image(),
            SizedBox(height: 10.h),
            Text(
              "${AppStrings.code.tr()} : ${widget.student.code ?? ''}",
              style: getSemiBoldStyle(
                  fontSize: 12.sp, color: ColorManager.greyTextColor),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 5.h,
            ),
            Text(
              "\t\t\t${AppStrings.stage.tr()} : ${widget.student.stageName ?? ''}",
              style: getMediumStyle(
                  fontSize: 12.sp, color: ColorManager.greyTextColor),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 5.h,
            ),
            Text(
              "\t\t\t${AppStrings.grade.tr()} : ${widget.student.gradeName ?? ''}",
              style: getMediumStyle(
                  fontSize: 12.sp, color: ColorManager.greyTextColor),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            if(instance<AppPreferences>().getUserType() == 'parent')
            _buttons(),
          ],
        ),
      ),
    );
  }

  _image() {
    return Stack(
      children: [
        DefaultImageWidget(
          image: widget.student.image ?? '',
          height: MediaQuery.sizeOf(context).height * .15,
          width: double.infinity,
        ),
        Positioned(
          left: 0,
          bottom: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: ColorManager.black.withOpacity(.3),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            child: Text(
              widget.student.name ?? '',
              style: getBoldStyle(fontSize: 13.sp, color: ColorManager.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  _buttons() {
    return Center(
      child: DefaultButtonWidget(
        onPressed: () {
          AppFunctions.navigateTo(context, DetailsView(id: widget.student.studentId??0,detailsType: DetailsType.student,student: widget.student,));
        },
        color: ColorManager.primary.withOpacity(.1),
        textColor: ColorManager.lightBlue,
        text: AppStrings.view.tr(),
        fontSize: 10.sp,
        elevation: 0,
        horizontalPadding: 15.w,
        isExpanded: false,
      ),
    );
  }
}
