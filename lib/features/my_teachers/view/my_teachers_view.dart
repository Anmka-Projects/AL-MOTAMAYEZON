import 'package:elmotamizon/app/app_functions.dart';
import 'package:elmotamizon/app/imports.dart';
import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/widgets/custom_pull_to_request.dart';
import 'package:elmotamizon/common/widgets/default_error_widget.dart';
import 'package:elmotamizon/features/details/models/course_details_model.dart';
import 'package:elmotamizon/features/home/view/widgets/teacher_widget.dart';
import 'package:elmotamizon/features/my_teachers/cubit/my_teachers_cubit.dart';
import 'package:elmotamizon/features/my_teachers/model/my_teachers_model.dart';
import 'package:elmotamizon/features/teacher_parent_home/cubit/courses/courses_cubit.dart';
import 'package:elmotamizon/features/teacher_parent_home/view/widgets/user_shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class TeachersView extends StatefulWidget {
  const TeachersView({super.key});

  @override
  State<TeachersView> createState() => _TeachersViewState();
}

class _TeachersViewState extends State<TeachersView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: BlocProvider(
        create: (context) => instance<CoursesCubit>()..loadFirstCoursesPage(),
        child: BlocConsumer<CoursesCubit, BaseState<CourseModel>>(
          listener: (context, state) {
            if (state.status == Status.failure) {
              AppFunctions.showsToast(state.errorMessage ?? 'An error occurred', ColorManager.red, context);
            }
          },
          builder: (context, state) {
            if (state.status == Status.failure) {
              return DefaultErrorWidget(errorMessage: state.errorMessage ?? '');
            }
              return PullToRefresh(
                enableRefresh: false,
                enableLoadMore: true,
                onLoadMore: () => context.read<CoursesCubit>().loadMoreCoursesPage(),
                builder: (context) {
                  return _teachers(state.items,state);
                }
              );
          },
        ),
      ),
    );
  }

  Widget _teachers(List<CourseModel>? teachers,BaseState<CourseModel> state) {
    return MasonryGridView.count(
      itemCount: state.status == Status.loading ? 8 : teachers?.length??0,
      padding: EdgeInsets.fromLTRB(
          15.w, MediaQuery.sizeOf(context).height * .07, 15.h, 15.h),
      crossAxisCount: 2,
      crossAxisSpacing: 10.w,
      mainAxisSpacing: 10.h,
      itemBuilder: (context, index) {
        return state.status == Status.loading ? const UserShimmerWidget() :  TeacherWidget(
          // teacherModel: (teachers??[])[index],
          myTeachers: true,
        );
      },
    );
  }
}
