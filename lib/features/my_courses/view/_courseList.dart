import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/extensions/context_extension.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/common/widgets/custom_pull_to_request.dart';
import 'package:elmotamizon/common/widgets/default_error_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:elmotamizon/features/details/models/course_details_model.dart';
import 'package:elmotamizon/features/home/Home/view/widgets/complete_learning_widget.dart';
import 'package:elmotamizon/features/home/Home/view/widgets/popular_books_item.dart';
import 'package:elmotamizon/features/my_courses/view/_courseItem.dart';
import 'package:elmotamizon/features/teacher_parent_home/cubit/courses/courses_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../home/Home/view/shimmer/CardRowShimmer.dart';

courseList({required final int currentIndex}) {
  return BlocBuilder<CoursesCubit, BaseState<CourseModel>>(
    builder: (context, state) {
      if (state.status == Status.loading) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(4, (index) => Padding(
                padding: EdgeInsetsDirectional.only(top: 20.h),
                child: const CardRowShimmer(),
              ),),
            ),
          ),
        );
      }
      if (state.status == Status.failure) {
        return DefaultErrorWidget(errorMessage: state.errorMessage ?? '');
      }
      if (state.items.isEmpty) {
        return DefaultErrorWidget(errorMessage: AppStrings.noData.tr());
      }
      return PullToRefresh(
          enableLoadMore: true,
          enableRefresh: true,
          onRefresh: () async {
             if (currentIndex == 1) {
              context
                  .read<CoursesCubit>()
                  .loadFirstCoursesPage(isCompleted: true, status: "completed");
            } else if (currentIndex == 2) {
              context
                  .read<CoursesCubit>()
                  .loadFirstCoursesPage(isFavorite: true);
            }
          },
          onLoadMore: () async {
             if (currentIndex == 1) {
               context
                   .read<CoursesCubit>()
                   .loadMoreCoursesPage(isCompleted: true, status: "completed");

            } else if (currentIndex == 2) {
               context
                   .read<CoursesCubit>()
                   .loadFirstCoursesPage(isFavorite: true);
            }
          },
          builder: (context) {
            return ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
              itemBuilder: (context, index) => state.items[index].isSubscribed==1 && currentIndex == 0 ? CompleteLearningWidget(course: state.items[index]) : courseItem(state.items[index],isCompleted: currentIndex == 1,isFavoriteAndSubscribed: currentIndex==2&&state.items[index].isSubscribed==1 ),
              separatorBuilder: (context, index) => SizedBox(
                height: 15.h,
              ),
              itemCount: state.items.length,
            );
          });
    },
  );
}
