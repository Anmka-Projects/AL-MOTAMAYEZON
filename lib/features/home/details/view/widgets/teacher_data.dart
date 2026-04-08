import 'package:easy_localization/easy_localization.dart';
import 'package:elmotamizon/app/app_functions.dart';
import 'package:elmotamizon/app/imports.dart';
import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/extensions/context_extension.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/common/widgets/default_error_widget.dart';
import 'package:elmotamizon/common/widgets/default_image_widget.dart';
import 'package:elmotamizon/constants/assets.dart';
import 'package:elmotamizon/features/home/Home/view/teacher_details_view.dart';
import 'package:elmotamizon/features/home/details/cubit/teacher_data/teacher_data_cubit.dart';
import 'package:elmotamizon/features/home/details/models/teacher_model.dart';
import 'package:elmotamizon/features/home/details/view/widgets/custom_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class TeacherView extends StatefulWidget {
  final Function()? onTap;
  const TeacherView({
    super.key, this.onTap,
  });

  @override
  State<TeacherView> createState() => _TeacherViewState();
}

class _TeacherViewState extends State<TeacherView> {

  @override
  void initState() {
    super.initState();
    instance<TeacherCubit>().getTeacher();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: instance<TeacherCubit>(),
      child: BlocBuilder<TeacherCubit, BaseState<TeacherDetailsModel>>(
        builder: (context, state) {
          if (state.status == Status.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state.status == Status.failure) {
            return DefaultErrorWidget(errorMessage: state.errorMessage ?? '');
          }

          final data = state.data?.data;
          return GestureDetector(
            onTap: state.status == Status.success
                ? () {
              if(widget.onTap != null) widget.onTap!.call();
                    AppFunctions.navigateTo(
                      context,
                      TeacherDetailsView(data: data),
                    );
                  }
                : () {},
            child: Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                border: Border.all(
                  color: ColorManager.borderColor.withOpacity(0.2),
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(10.r),
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 80.w,
                    height: 80.h,
                    child: DefaultImageWidget(
                      radius: 50.r,
                      image: data?.image ?? "",
                      //"https://almutamayizun.besohola.com/uploads/courses//1757847448_68c69f98cce51_about_2.jpg",
                    ),

                    // CircleAvatar(
                    //   radius: 40.r,
                    //   backgroundImage: const DefaultImageWidget(
                    //       image:
                    //           "https://almutamayizun.besohola.com/uploads/courses//1757847448_68c69f98cce51_about_2.jpg"),
                    // ),
                  ),
                  Gap(20.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTitle(title: data?.name ?? ""),
                        Row(
                          spacing: 5,
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                spacing: 10.w,
                                children: [
                                  SvgPicture.asset(
                                    Assets.assetsIconsStudent,
                                    width: 20.w,
                                    height: 20.h,
                                  ),
                                  Expanded(
                                    child: Text(
                                      //طالب
                                      "${data?.users} ${AppStrings.studens.tr()}",
                                      style: context.textTheme.bodyMedium!
                                          .copyWith(
                                        color: ColorManager.textGrayColor,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                spacing: 10.w,
                                children: [
                                  SvgPicture.asset(
                                    Assets.assetsIconsPlayCourse,
                                    width: 20.w,
                                    height: 20.h,
                                  ),
                                  Expanded(
                                    child: Text(
                                      //كورس
                                      "${data?.courses} ${AppStrings.course.tr()}",
                                      style: context.textTheme.bodyMedium!
                                          .copyWith(
                                        color: ColorManager.textGrayColor,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Gap(20.w),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
