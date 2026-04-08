import 'package:easy_localization/easy_localization.dart';
import 'package:elmotamizon/app/app_functions.dart';
import 'package:elmotamizon/app/imports.dart';
import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/extensions/context_extension.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/common/widgets/default_error_widget.dart';
import 'package:elmotamizon/features/bottom_nav_bar/view/bottom_nav_bar_view.dart';
import 'package:elmotamizon/features/details/models/course_details_model.dart';
import 'package:elmotamizon/features/home/Home/view/shimmer/CardRowShimmer.dart';
import 'package:elmotamizon/features/home/Home/view/widgets/complete_learning_widget.dart';
import 'package:elmotamizon/features/home/Home/view/widgets/title_widget.dart';
import 'package:elmotamizon/features/home/details/view/details.dart';
import 'package:elmotamizon/features/teacher_parent_home/cubit/courses/courses_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

Widget continueWatching({bool isMyCoursesPage = false, required int loadingLength}) {
  return BlocProvider(
    create: (context) => instance<CoursesCubit>()
      ..loadFirstCoursesPage(inProgress: true, status: "incomplete"),
    child: BlocConsumer<CoursesCubit, BaseState<CourseModel>>(
      listener: (context, state) {
        if (state.status == Status.failure) {
          AppFunctions.showsToast(state.errorMessage ?? 'An error occurred',
              ColorManager.red, context);
        }
      },
      builder: (context, state) {
        if (state.items.isEmpty && state.isSuccess && !isMyCoursesPage) {
          return const SizedBox.shrink();
        }
        if (state.isSuccess && state.items.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(15.h),
              DefaultErrorWidget(errorMessage: AppStrings.noData.tr()),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMyCoursesPage)
              TitleWidget(
                title: AppStrings.completeTheWatched.tr(),
                onTap: () {
                  AppFunctions.navigateTo(
                    context,
                    const BottomNavBarView(pageIndex: 0),
                  );
                },
              ),
            Gap(15.h),
            if (state.isLoading)
              Column(
                children: List.generate(
                  loadingLength,
                  (index) => Padding(
                    padding: EdgeInsets.only(bottom: 15.h),
                    child: const CardRowShimmer(),
                  ),
                ),
              )
            else if (state.isFailure)
              DefaultErrorWidget(errorMessage: state.errorMessage ?? '')
            else
              Column(
                children: List.generate(
                  !isMyCoursesPage && state.items.length > 2 ? 2 : state.items.length,
                  (index) => Padding(
                    padding: EdgeInsets.only(bottom: 15.h),
                    child: GestureDetector(
                        onTap: () {
                          AppFunctions.navigateTo(
                            context,
                            Details(id: "${state.items[index].id}"),
                          );
                        },
                        child:
                            CompleteLearningWidget(course: state.items[index])),
                  ),
                ),
              ),
          ],
        );
      },
    ),
  );
}
