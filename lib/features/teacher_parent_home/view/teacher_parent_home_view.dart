import 'package:elmotamizon/app/app_prefs.dart';
import 'package:elmotamizon/app/imports.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/features/home/view/widgets/home_app_bar_widget.dart';
import 'package:elmotamizon/features/teacher_parent_home/cubit/students/students_cubit.dart';
import 'package:elmotamizon/features/teacher_parent_home/view/widgets/assign_student_widget.dart';
import 'package:elmotamizon/features/teacher_parent_home/view/widgets/students_widget.dart';
import 'package:elmotamizon/features/teacher_parent_home/view/widgets/teacher_parent_home_courses_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TeacherParentHomeView extends StatefulWidget {
  const TeacherParentHomeView({super.key});

  @override
  State<TeacherParentHomeView> createState() => _TeacherParentHomeViewState();
}

class _TeacherParentHomeViewState extends State<TeacherParentHomeView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => instance<StudentsCubit>()..loadFirstStudentsPage(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: ColorManager.bg,
            body: ListView(
              padding: EdgeInsets.only(bottom: 15.h),
              physics: const ClampingScrollPhysics(),
              children: [
                HomeAppBarWidget(studentsOrTeachersContext: context,isStudent: false,),
                AssignStudentWidget(studentsContext: context,),
                 StudentsWidget(studentsContext: context),
                if(instance<AppPreferences>().getUserType() == 'teacher')
                  const TeacherParentHomeVCoursesWidget(),
              ],
            ),
          );
        }
      ),
    );
  }
}
