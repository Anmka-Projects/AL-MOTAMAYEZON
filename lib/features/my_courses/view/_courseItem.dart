import 'package:elmotamizon/app/app_functions.dart';
import 'package:elmotamizon/app/imports.dart';
import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/styles_manager.dart';
import 'package:elmotamizon/common/widgets/default_button_widget.dart';
import 'package:elmotamizon/common/widgets/default_image_widget.dart';
import 'package:elmotamizon/features/details/cubit/subscribe_teacher_cubit.dart';
import 'package:elmotamizon/features/details/models/course_details_model.dart';
import 'package:elmotamizon/features/home/details/view/details.dart';
import 'package:elmotamizon/features/payment/digital_payment_order_place_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

courseItem(CourseModel course,{
  bool isCompleted = false,
  bool isFavoriteAndSubscribed = false,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
    decoration: BoxDecoration(
      color: ColorManager.white,
      borderRadius: BorderRadius.circular(10.r),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withValues(alpha: 0.3),
          blurRadius: 5.r,
        )
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: DefaultImageWidget(
              height: 80,
              image: course.image ?? '',
              radius: 10.r,
            )),
        SizedBox(
          width: 10.w,
        ),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                course.name ?? '',
                style: getBoldStyle(fontSize: 15.sp, color: ColorManager.black),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 5.h,
              ),
              Text(
                course.description ?? '',
                style: getRegularStyle(
                    fontSize: 12.sp, color: ColorManager.primary),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              // SizedBox(height: 10.h,),
              // Row(
              //   children: [
              //     Icon(Icons.play_circle_fill,color: ColorManager.primary,size: 16.r,),
              //     SizedBox(width: 5.w,),
              //     Text("10 دروس",style: getRegularStyle(fontSize: 12.sp,color: ColorManager.blackText),),
              //     SizedBox(width: 15.w,),
              //     Icon(Icons.access_time_filled,color: ColorManager.primary,size: 16.r,),
              //     SizedBox(width: 5.w,),
              //     Text("3 ساعات",style: getRegularStyle(fontSize: 12.sp,color: ColorManager.blackText),),
              //   ],
              // ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  BlocProvider(
                    create: (context) =>
                        instance<SubscribeTeacherCubit>(),
                    child: BlocConsumer<SubscribeTeacherCubit,
                        BaseState<String>>(
                      listener: (context, state) {
                        if (state.status == Status.success) {
                          // if (instance<AppPreferences>()
                          //     .getUserIsAppleReview() !=
                          //     1) {
                          AppFunctions.navigateTo(
                              context,
                              DigitalPaymentView(
                                url: state.data ?? '',
                              ));
                          // } else {
                          //   courseState.data?.data?.isSubscribed = 1;
                          //   setState(() {});
                          // }
                        } else if (state.status == Status.failure) {
                          AppFunctions.showsToast(
                              state.errorMessage ?? '',
                              ColorManager.red,
                              context);
                        }
                      },
                      builder: (context, subscribeState) {
                        return DefaultButtonWidget(
                          text: isFavoriteAndSubscribed ? "مشاهدة الكورس" : isCompleted ? "مراجعة الكورس" : "اشترك الان",
                          fontSize: 12.sp,
                          onPressed: () {
                            if(isCompleted || isFavoriteAndSubscribed){
                              AppFunctions.navigateTo(context, Details(id: (course.id??0).toString()));
                            }else{
                              context
                                  .read<SubscribeTeacherCubit>()
                                  .subscribeTeacher(
                                teacherId: course.id ?? 0,
                              );
                            }
                          },
                          horizontalPadding: 15.w,
                          isExpanded: false,
                          radius: 7.r,
                          color: ColorManager.primary,
                          textColor: ColorManager.white,
                          isLoading: subscribeState.isLoading,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
