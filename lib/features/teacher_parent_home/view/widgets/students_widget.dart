import 'package:elmotamizon/app/app_prefs.dart';
import 'package:elmotamizon/app/imports.dart';
import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/common/resources/styles_manager.dart';
import 'package:elmotamizon/common/widgets/custom_pull_to_request.dart';
import 'package:elmotamizon/common/widgets/default_error_widget.dart';
import 'package:elmotamizon/features/teacher_parent_home/cubit/students/students_cubit.dart';
import 'package:elmotamizon/features/teacher_parent_home/models/students_model.dart';
import 'package:elmotamizon/features/teacher_parent_home/view/widgets/student_widget.dart';
import 'package:elmotamizon/features/teacher_parent_home/view/widgets/user_shimmer_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentsWidget extends StatefulWidget {
  final BuildContext studentsContext;
  const StudentsWidget({super.key, required this.studentsContext,});

  @override
  State<StudentsWidget> createState() => _StudentsWidgetState();
}

class _StudentsWidgetState extends State<StudentsWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Text(instance<AppPreferences>().getUserType() == 'parent' ? AppStrings.children.tr() : AppStrings.students.tr(),style: getBoldStyle(fontSize: 15.sp, color: ColorManager.black),),
          ),
          SizedBox(height: 15.h,),
          BlocBuilder<StudentsCubit, BaseState<StudentModel>>(
            builder: (context, state) {
              if (state.status == Status.failure) {
                return DefaultErrorWidget(errorMessage: state.errorMessage ?? '');
              }
              return PullToRefresh(
                enableRefresh: false,
                enableLoadMore: true,
                onLoadMore: () => widget.studentsContext.read<StudentsCubit>().loadMoreStudentsPage(),
                builder: (controller) => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: IntrinsicHeight(
                    child: Row(
                      children: List.generate(state.status == Status.loading ? 5 : state.items.length, (index) => Padding(
                        padding: EdgeInsetsDirectional.only(start: 15.w,end: 15.w),
                        child: state.status == Status.loading ? const UserShimmerWidget() : StudentWidget(student: state.items[index],),
                      ),),
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
