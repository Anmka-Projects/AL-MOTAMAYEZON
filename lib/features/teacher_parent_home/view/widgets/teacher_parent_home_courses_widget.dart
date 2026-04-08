import 'package:elmotamizon/app/app_prefs.dart';
import 'package:elmotamizon/app/imports.dart';
import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/features/details/models/course_details_model.dart';
import 'package:elmotamizon/features/details/models/course_or_lesson_or_exam_or_homework_model.dart';
import 'package:elmotamizon/features/details/view/widgets/course_or_lesson_or_exam_or_homework_widget.dart';
import 'package:elmotamizon/features/teacher_parent_home/cubit/courses/courses_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherParentHomeVCoursesWidget extends StatefulWidget {
  const TeacherParentHomeVCoursesWidget({super.key});

  @override
  State<TeacherParentHomeVCoursesWidget> createState() =>
      _TeacherParentHomeVCoursesWidgetState();
}

class _TeacherParentHomeVCoursesWidgetState
    extends State<TeacherParentHomeVCoursesWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => instance<CoursesCubit>()..loadFirstCoursesPage(),
      child: _items(),
    );
  }

  _items() {
    return BlocBuilder<CoursesCubit, BaseState<CourseModel>>(
      builder: (context, state) {
        return CourseOrLessonOrExamOrHomeWorkWidget(
          type: ItemType.course,
          title: instance<AppPreferences>().getUserType() == 'parent'
              ? AppStrings.yourChildrenCourses.tr()
              : AppStrings.yourCourses.tr(),
          data: state.items
              .map((e) => CourseOrLessonOrExamOrHomeworkModel(
                    course: e,
                  ))
              .toList(),
          state: state,
          showShimmer: state.status == Status.loading,
          errorMessage: state.errorMessage,
          context: context,
        );
      },
    );
  }
}
