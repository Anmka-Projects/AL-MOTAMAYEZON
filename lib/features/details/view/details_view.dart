import 'package:elmotamizon/app/app_functions.dart';
import 'package:elmotamizon/app/app_prefs.dart';
import 'package:elmotamizon/app/imports.dart';
import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/resources/assets_manager.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/common/resources/styles_manager.dart';
import 'package:elmotamizon/common/widgets/default_button_widget.dart';
import 'package:elmotamizon/common/widgets/default_error_widget.dart';
import 'package:elmotamizon/features/details/cubit/course_details/course_details_cubit.dart';
import 'package:elmotamizon/features/details/cubit/lessons/lessons_cubit.dart';
import 'package:elmotamizon/features/details/cubit/subscribe_teacher_cubit.dart';
import 'package:elmotamizon/features/details/models/course_details_model.dart';
import 'package:elmotamizon/features/details/models/course_or_lesson_or_exam_or_homework_model.dart';
import 'package:elmotamizon/features/details/view/widgets/header_image_widget.dart';
import 'package:elmotamizon/features/exam_details/models/exam_details_model.dart';
import 'package:elmotamizon/features/lesson_details/cubit/homeworks/homeworks_cubit.dart';
import 'package:elmotamizon/features/lesson_details/cubit/tests_cubit/tests_cubit.dart';
import 'package:elmotamizon/features/lesson_details/models/homeworks_model.dart';
import 'package:elmotamizon/features/lesson_details/models/lesson_details_model.dart';
import 'package:elmotamizon/features/details/view/widgets/course_or_lesson_or_exam_or_homework_widget.dart';
import 'package:elmotamizon/features/my_teachers/model/my_teachers_model.dart';
import 'package:elmotamizon/features/payment/digital_payment_order_place_screen.dart';
import 'package:elmotamizon/features/teacher_parent_home/cubit/courses/courses_cubit.dart';
import 'package:elmotamizon/features/teacher_parent_home/models/students_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

enum DetailsType { course, student, teacher }

class DetailsView extends StatefulWidget {
  final DetailsType detailsType;
  final int id;
  final TeacherModel? teacher;
  final StudentModel? student;

  const DetailsView(
      {super.key,
      required this.detailsType,
      required this.id,
      this.teacher,
      this.student});

  @override
  State<DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        if (widget.detailsType == DetailsType.teacher ||
            widget.detailsType == DetailsType.student)
          BlocProvider(
            create: (context) => instance<CoursesCubit>(),
          )
        else if (widget.detailsType == DetailsType.course)
          BlocProvider(
            create: (context) => instance<CourseDetailsCubit2>()
              ..getCourseDetails(widget.id.toString()),
          ),
      ],
      child: Scaffold(
        backgroundColor: ColorManager.bg,
        body: widget.detailsType == DetailsType.course
            ? _courseDetailsBlocBuilder()
            : widget.detailsType == DetailsType.teacher
                ? _body(teacher: widget.teacher)
                : _body(student: widget.student),
        bottomNavigationBar: widget.detailsType != DetailsType.course
            ? null
            : BlocBuilder<CourseDetailsCubit2, BaseState<CourseDetailsModel>>(
                builder: (context, state) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return state.data?.data?.isSubscribed != 1 &&
                              instance<AppPreferences>().getUserType() ==
                                  'student'
                          ? Padding(
                              padding:
                                  EdgeInsets.fromLTRB(20.w, 5.h, 20.w, 20.h),
                              child: BlocProvider(
                                create: (context) =>
                                    instance<SubscribeTeacherCubit>(),
                                child: BlocConsumer<SubscribeTeacherCubit,
                                    BaseState<String>>(
                                  listener: (context, state) {
                                    if (state.status == Status.success) {
                                      if (instance<AppPreferences>()
                                              .getUserIsAppleReview() !=
                                          1) {
                                        AppFunctions.navigateTo(
                                            context,
                                            DigitalPaymentView(
                                                url: state.data ?? ''));
                                      } else {
                                        widget.teacher?.isSubscribed = 1;
                                        setState(() {});
                                      }
                                    } else if (state.status == Status.failure) {
                                      AppFunctions.showsToast(
                                          state.errorMessage ?? '',
                                          ColorManager.red,
                                          context);
                                    }
                                  },
                                  builder: (context, subscribeState) {
                                    return DefaultButtonWidget(
                                        text:
                                            "${AppStrings.subscribe.tr()} - ${state.data?.data?.price ?? ''} ${AppStrings.pound.tr()}",
                                        color: ColorManager.primary,
                                        textColor: ColorManager.white,
                                        onPressed: () async {
                                          if (instance<AppPreferences>()
                                                  .getUserIsAppleReview() ==
                                              1) {
                                            try {
                                              await Purchases.purchaseStoreProduct(
                                                  const StoreProduct(
                                                      "elmotamizon_mon",
                                                      "Access Courses for 1 month",
                                                      "Access Course - Monthly",
                                                      0.99,
                                                      "0.99",
                                                      "USD"));
                                            } catch (e) {}
                                          }
                                          context
                                              .read<SubscribeTeacherCubit>()
                                              .subscribeTeacher(
                                                teacherId:
                                                    state.data?.data?.id ?? 0,
                                              );
                                        },
                                        isLoading: subscribeState.status ==
                                            Status.loading);
                                  },
                                ),
                              ),
                            )
                          : const SizedBox.shrink();
                    },
                  );
                },
              ),
      ),
    );
  }

  Widget _courseDetailsBlocBuilder() {
    return BlocBuilder<CourseDetailsCubit2, BaseState<CourseDetailsModel>>(
      builder: (context, state) {
        if (state.status == Status.failure) {
          return DefaultErrorWidget(errorMessage: state.errorMessage ?? '');
        }
        if (state.status == Status.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return _body<CourseDetailsModel>(
          courseModel: state.data?.data,
        );
      },
    );
  }

  _body<T>({
    CourseModel? courseModel,
    TeacherModel? teacher,
    StudentModel? student,
  }) {
    return ListView(
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.only(bottom: 20.h),
      children: [
        if (widget.detailsType == DetailsType.teacher)
          HeaderImageWidget(
              name: teacher?.name ?? '', image: teacher?.image ?? ''),
        if (widget.detailsType == DetailsType.student)
          HeaderImageWidget(
              name: student?.name ?? '', image: student?.image ?? ''),
        if (widget.detailsType == DetailsType.course)
          HeaderImageWidget(
              name: courseModel?.name ?? '', image: courseModel?.image ?? ''),
        Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.detailsType == DetailsType.student
                        ? AppStrings.studentOverview.tr()
                        : widget.detailsType == DetailsType.course
                            ? AppStrings.aboutTheCourse.tr()
                            : AppStrings.aboutTheTeacher.tr(),
                    style: getBoldStyle(
                        fontSize: 14.sp, color: ColorManager.blackText),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  _about(
                    about: widget.detailsType == DetailsType.course
                        ? courseModel?.description ?? ''
                        : widget.detailsType == DetailsType.teacher
                            ? teacher?.bio ?? ''
                            : "${AppStrings.studentCode.tr()}: ${widget.student?.code ?? ''}\n${AppStrings.stage.tr()}: ${widget.student?.stageName ?? ''}\n${AppStrings.grade.tr()}: ${widget.student?.gradeName ?? ''}\n${AppStrings.phoneNumber.tr()}: ${widget.student?.phone ?? ''}",
                  ),
                  if (widget.detailsType == DetailsType.course)
                    SizedBox(
                      height: 15.h,
                    ),
                  if (widget.detailsType == DetailsType.course)
                    _whatYouLearn(courseModel?.whatYouWillLearn ?? ''),
                  SizedBox(
                    height: 5.h,
                  ),
                ],
              ),
            ),
            if (widget.detailsType == DetailsType.course) _lessonsBloc(),
            if (widget.detailsType == DetailsType.teacher ||
                (widget.detailsType == DetailsType.student &&
                    instance<AppPreferences>().getUserType() == "parent"))
              _coursesBloc(),
            if (widget.detailsType == DetailsType.student) ...[
              BlocProvider(
                create: (context) => instance<TestsCubit>()
                  ..loadFirstTestsPage(widget.id,
                      isStudentDetails:
                          widget.detailsType == DetailsType.student),
                child: BlocBuilder<TestsCubit, BaseState<ExamModel>>(
                  builder: (context, state) {
                    return CourseOrLessonOrExamOrHomeWorkWidget(
                      data: state.items.isEmpty
                          ? [
                              CourseOrLessonOrExamOrHomeworkModel(
                                lesson: Lesson2Model(id: widget.id),
                              ),
                            ]
                          : state.items
                              .map(
                                (e) => CourseOrLessonOrExamOrHomeworkModel(
                                    lesson: Lesson2Model(id: widget.id),
                                    exam: e),
                              )
                              .toList(),
                      type: ItemType.exam,
                      title: AppStrings.exams.tr(),
                      state: state,
                      showShimmer: state.status == Status.loading,
                      errorMessage: state.errorMessage,
                      context: context,
                      showAddButton: false,
                      isStudentDetails:
                          widget.detailsType == DetailsType.student,
                    );
                  },
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              BlocProvider(
                create: (context) => instance<HomeworksCubit>()
                  ..loadFirstHomeworksPage(widget.id,
                      isStudentDetails:
                          widget.detailsType == DetailsType.student),
                child: BlocBuilder<HomeworksCubit, BaseState<HomeworkModel>>(
                  builder: (context, state) {
                    return CourseOrLessonOrExamOrHomeWorkWidget(
                      data: state.items.isEmpty
                          ? [
                              CourseOrLessonOrExamOrHomeworkModel(
                                lesson: Lesson2Model(id: widget.id),
                              ),
                            ]
                          : state.items
                              .map(
                                (e) => CourseOrLessonOrExamOrHomeworkModel(
                                    lesson: Lesson2Model(id: widget.id),
                                    homework: e),
                              )
                              .toList(),
                      type: ItemType.homework,
                      title: AppStrings.homeworks.tr(),
                      state: state,
                      showShimmer: state.status == Status.loading,
                      errorMessage: state.errorMessage,
                      context: context,
                      showAddButton: false,
                      isStudentDetails:
                          widget.detailsType == DetailsType.student,
                    );
                  },
                ),
              ),
            ]
          ],
        ),
      ],
    );
  }

  _lessonsBloc() {
    return BlocProvider(
      create: (context) =>
          instance<Lessons2Cubit>()..loadFirstLessonsPage(widget.id),
      child: BlocBuilder<Lessons2Cubit, BaseState<Lesson2Model>>(
        builder: (context, state) {
          return CourseOrLessonOrExamOrHomeWorkWidget(
            showShimmer: state.status == Status.loading,
            type: ItemType.lesson,
            title: AppStrings.courseLessons.tr(),
            state: state,
            errorMessage: state.errorMessage,
            data: state.items.isEmpty
                ? [
                    CourseOrLessonOrExamOrHomeworkModel(
                      course: CourseModel(id: widget.id),
                    )
                  ]
                : state.items
                    .map((e) => CourseOrLessonOrExamOrHomeworkModel(
                          course: CourseModel(id: widget.id),
                          lesson: e,
                        ))
                    .toList(),
            context: context,
          );
        },
      ),
    );
  }

  _coursesBloc() {
    return BlocProvider(
      create: (context) =>
          instance<CoursesCubit>()..loadFirstCoursesPage(teacherId: widget.id),
      child: BlocBuilder<CoursesCubit, BaseState<CourseModel>>(
        builder: (context, state) {
          return CourseOrLessonOrExamOrHomeWorkWidget(
            teacherId: widget.id,
            showShimmer: state.status == Status.loading,
            type: ItemType.course,
            title: widget.detailsType == DetailsType.student
                ? AppStrings.studentCourses.tr()
                : AppStrings.teacherCourses.tr(),
            state: state,
            errorMessage: state.errorMessage,
            data: state.items
                .map((e) => CourseOrLessonOrExamOrHomeworkModel(
                      course: e,
                    ))
                .toList(),
            context: context,
            showAddButton: false,
          );
        },
      ),
    );
  }

  _about({
    required String about,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: ColorManager.white,
      ),
      child: Text(
        about,
        style: getSemiBoldStyle(
            fontSize: 13.sp, color: ColorManager.blackText, height: 2.3.h),
      ),
    );
  }

  _whatYouLearn(String text) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.whatYouLearnInThisCourseAr.tr(),
          style: getBoldStyle(fontSize: 14.sp, color: ColorManager.blackText),
        ),
        SizedBox(
          height: 10.h,
        ),
        Container(
          padding: EdgeInsets.fromLTRB(15.w, 15.h, 15.w, 5.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: ColorManager.white,
          ),
          child: Column(
            children: List.generate(
              1,
              (index) => Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(IconAssets.done),
                    SizedBox(
                      width: 10.w,
                    ),
                    Expanded(
                        child: Text(
                      text,
                      style: getMediumStyle(
                          fontSize: 12.sp, color: ColorManager.blackText),
                    )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
