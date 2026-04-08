import 'package:elmotamizon/app/imports.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/common/resources/styles_manager.dart';
import 'package:elmotamizon/common/widgets/default_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:elmotamizon/features/home/Home/view/widgets/continue_watching.dart';
import 'package:elmotamizon/features/my_courses/view/_courseList.dart';
import 'package:elmotamizon/features/teacher_parent_home/cubit/courses/courses_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyCoursesView extends StatefulWidget {
  const MyCoursesView({super.key});

  @override
  State<MyCoursesView> createState() => _MyCoursesViewState();
}

class _MyCoursesViewState extends State<MyCoursesView> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        text: AppStrings.myCourses.tr(),
        withLeading: false,
        backgroundColor: ColorManager.white,
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            _tabBar(),
            Expanded(
              child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    ListView(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      children: [
                        continueWatching(
                            isMyCoursesPage: true, loadingLength: 4),
                      ],
                    ),
                    BlocProvider(
                      create: (context) => instance<CoursesCubit>()
                        ..loadFirstCoursesPage(
                            isCompleted: true, status: "completed"),
                      child: courseList(currentIndex: 1),
                    ),
                    BlocProvider(
                      create: (context) => instance<CoursesCubit>()
                        ..loadFirstCoursesPage(isFavorite: true),
                      child: courseList(currentIndex: 2),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  StatefulBuilder _tabBar() {
    return StatefulBuilder(builder: (context, setState) {
      return TabBar(
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          dividerColor: Colors.transparent,
          indicatorColor: Colors.transparent,
          isScrollable: true,
          tabAlignment: TabAlignment.center,
          labelPadding: EdgeInsetsDirectional.symmetric(horizontal: 5.w),
          onTap: (value) {
            _currentIndex = value;
            // if(value == 0){
            //   context.read<CoursesCubit>().loadFirstCoursesPage(isFavorite: true);
            // } else if(value == 1){
            //   context.read<CoursesCubit>().loadFirstCoursesPage(inProgress: true);
            // } else if(value == 2){
            //   context.read<CoursesCubit>().loadFirstCoursesPage(isCompleted: true);
            // }
            setState(() {});
          },
          tabs: [
            _tabItem(
              isSelected: _currentIndex == 0,
              text: AppStrings.currentCourses.tr(),
            ),
            _tabItem(
              isSelected: _currentIndex == 1,
              text: AppStrings.completedCourses.tr(),
            ),
            _tabItem(
              isSelected: _currentIndex == 2,
              text: AppStrings.savedCourses.tr(),
            ),
          ]);
    });
  }

  Widget _tabItem({
    required String text,
    required bool isSelected,
  }) {
    return AnimatedContainer(
      width: 130.w,
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
        decoration: BoxDecoration(
            color: isSelected ? ColorManager.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: ColorManager.primary,
            )),
        child: Text(
          text,
          style: getBoldStyle(
              fontSize: 13.sp,
              color: isSelected ? ColorManager.white : ColorManager.primary),
          textAlign: TextAlign.center,
        ));
  }
}
