import 'package:elmotamizon/app/app_functions.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/language_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/common/resources/styles_manager.dart';
import 'package:elmotamizon/common/widgets/default_button_widget.dart';
import 'package:elmotamizon/common/widgets/default_image_widget.dart';
import 'package:elmotamizon/features/details/view/details_view.dart';
import 'package:elmotamizon/features/my_teachers/model/my_teachers_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TeacherWidget extends StatefulWidget {
  const TeacherWidget({super.key, this.teacherModel, this.myTeachers = false});
  final TeacherModel? teacherModel;
  final bool myTeachers;

  @override
  State<TeacherWidget> createState() => _TeacherWidgetState();
}

class _TeacherWidgetState extends State<TeacherWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => AppFunctions.navigateTo(
          context,
          DetailsView(
            detailsType: DetailsType.teacher,
            id: widget.teacherModel?.id ?? 0,
            teacher: widget.teacherModel,
          ),
      ),
      borderRadius: BorderRadius.circular(15.r),
      child: Container(
        width: 190.w,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _image(widget.teacherModel?.image, widget.teacherModel?.name ?? "", widget.teacherModel?.price ?? 0),
            if((widget.teacherModel?.bio ?? "").isNotEmpty)
            SizedBox(
              height: 10.h,
            ),
            if((widget.teacherModel?.bio ?? "").isNotEmpty)
            Text(
              widget.teacherModel?.bio ?? "",
              style: getMediumStyle(fontSize: 14.sp, color: ColorManager.greyTextColor),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 5.h,
            ),
            if(!widget.myTeachers)
            const Spacer(),
            _buttons(),
          ],
        ),
      ),
    );
  }

  _image(String? imageUrl, String name, int price) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * .15,
      child: Stack(
        children: [
          DefaultImageWidget(image: imageUrl ?? ""),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.w),
                    decoration: BoxDecoration(
                        color: ColorManager.white,
                        borderRadius: BorderRadiusDirectional.only(
                            bottomStart: Radius.circular(15.r))),
                    child: Text(
                      language == "ar" ? "$price ج.م/ شهر" : "$price EGP/M",
                      style:
                      getMediumStyle(fontSize: 11.sp, color: ColorManager.black),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5.w),
                padding: EdgeInsets.symmetric(horizontal: 5.w,vertical: 5.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: ColorManager.black.withOpacity(.4),
                ),
                child: Text(
                  "\t\t$name",
                  style: getBoldStyle(fontSize: 11.sp, color: ColorManager.white),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(height: 5.h,),
            ],
          ),
        ],
      ),
    );
  }

  _buttons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 5.h),
      child: Row(
        children: [
          Expanded(
            child: DefaultButtonWidget(
              // onPressed: () {},
              borderColor: ColorManager.lightBlue,
              color: Colors.transparent,
              withBorder: true,
              textColor: ColorManager.lightBlue,
              text: AppStrings.details.tr(),
              fontSize: 10.sp,
              elevation: 0,
            ),
          ),
          if(!widget.myTeachers)
          SizedBox(
            width: 5.w,
          ),
          if(!widget.myTeachers)
          Expanded(
            child: DefaultButtonWidget(
              // onPressed: () {},
              color: ColorManager.primary.withOpacity(.1),
              textColor: ColorManager.lightBlue,
              text: AppStrings.subscribe.tr(),
              fontSize: 10.sp,
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}
