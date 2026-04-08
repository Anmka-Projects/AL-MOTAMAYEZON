import 'package:elmotamizon/app/app_prefs.dart';
import 'package:elmotamizon/app/app_functions.dart';
import 'package:elmotamizon/app/imports.dart';
import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/resources/assets_manager.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/common/resources/styles_manager.dart';
import 'package:elmotamizon/common/widgets/default_button_widget.dart';
import 'package:elmotamizon/common/widgets/default_image_widget.dart';
import 'package:elmotamizon/common/widgets/default_error_widget.dart';
import 'package:elmotamizon/common/widgets/shimmer_container_widget.dart';
import 'package:elmotamizon/features/add_course/view/add_course_view.dart';
import 'package:elmotamizon/features/add_exam/view/add_exam_view.dart';
import 'package:elmotamizon/features/add_homework/view/add_homework_view.dart';
import 'package:elmotamizon/features/add_lesson/view/add_lesson_view.dart';
import 'package:elmotamizon/features/auth/login/view/login_view.dart';
import 'package:elmotamizon/features/details/cubit/lessons/lessons_cubit.dart';
import 'package:elmotamizon/features/details/models/course_or_lesson_or_exam_or_homework_model.dart';
import 'package:elmotamizon/features/details/view/details_view.dart';
import 'package:elmotamizon/features/exam_details/models/exam_details_model.dart';
import 'package:elmotamizon/features/exam_details/view/exam_details_view.dart';
import 'package:elmotamizon/features/exam_details/view/exam_submission_details_view.dart';
import 'package:elmotamizon/features/homework_details/view/homework_details_view.dart';
import 'package:elmotamizon/features/lesson_details/cubit/homeworks/homeworks_cubit.dart';
import 'package:elmotamizon/features/lesson_details/cubit/tests_cubit/tests_cubit.dart';
import 'package:elmotamizon/features/lesson_details/view/lesson_details_view.dart';
import 'package:elmotamizon/features/teacher_parent_home/cubit/courses/courses_cubit.dart';
import 'package:elmotamizon/features/teacher_parent_home/cubit/delete_active_course_or_lesson/delete_active_course_or_lesson_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CourseOrLessonOrExamOrHomeWorkWidget<T> extends StatefulWidget {
  final String title;
  final String? errorMessage;
  final ItemType type;
  final List<CourseOrLessonOrExamOrHomeworkModel>? data;
  final BaseState<T>? state;
  final bool showShimmer;
  final int? teacherId;
  final BuildContext context;
  final bool? showAddButton;
  final bool isStudentDetails;
  final Function(int? currentExamId)? currentExamId;

  CourseOrLessonOrExamOrHomeWorkWidget({
    super.key,
    this.title = '',
    required this.type,
    this.data,
    this.state,
    this.showShimmer = false,
    this.errorMessage,
    this.teacherId,
    required this.context,
    this.showAddButton,
    this.currentExamId,
    this.isStudentDetails = false,
  }) {
    if (type == ItemType.exam &&
        currentExamId != null &&
        (data ?? []).isNotEmpty) {
      currentExamId!(data?[0].exam?.id);
    }
  }

  @override
  State<CourseOrLessonOrExamOrHomeWorkWidget> createState() =>
      _CourseOrLessonOrExamOrHomeWorkWidgetState();
}

class _CourseOrLessonOrExamOrHomeWorkWidgetState
    extends State<CourseOrLessonOrExamOrHomeWorkWidget> {
  final PageController _coursesController = PageController();
  bool _isDelete = false;
  late DeleteActiveCourseOrLessonCubit _deleteActiveCourseOrLessonCubit;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => instance<DeleteActiveCourseOrLessonCubit>(),
      child: BlocListener<DeleteActiveCourseOrLessonCubit, BaseState<String>>(
        listener: (context, state) {
          if (state.status == Status.success) {
            AppFunctions.showsToast(
                state.data ?? '', ColorManager.successGreen, context);
            if (widget.type == ItemType.course)
              widget.context.read<CoursesCubit>().loadFirstCoursesPage();
            if (widget.type == ItemType.lesson)
              widget.context
                  .read<Lessons2Cubit>()
                  .loadFirstLessonsPage(widget.data?.first.course?.id ?? 0);
            if (widget.type == ItemType.homework)
              widget.context
                  .read<HomeworksCubit>()
                  .loadFirstHomeworksPage(widget.data?.first.lesson?.id ?? 0);
            if (widget.type == ItemType.exam)
              widget.context
                  .read<TestsCubit>()
                  .loadFirstTestsPage(widget.data?.first.lesson?.id ?? 0);
          } else if (state.status == Status.failure) {
            AppFunctions.showsToast(
                state.errorMessage ?? '', ColorManager.red, context);
          }
        },
        child: _items(),
      ),
    );
  }

  Widget _items() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Text(
              widget.title,
              style:
                  getBoldStyle(fontSize: 14.sp, color: ColorManager.blackText),
            ),
          ),
        SizedBox(
          height: 10.h,
        ),
        (widget.errorMessage == null)
            ? ExpandablePageView.builder(
                scrollDirection: Axis.horizontal,
                controller: _coursesController,
                onPageChanged: (int index) {
                  if ((widget.data?.length ?? 0) - 1 == index) {
                    if (widget.type == ItemType.course) {
                      widget.context
                          .read<CoursesCubit>()
                          .loadMoreCoursesPage(teacherId: widget.teacherId);
                    } else if (widget.type == ItemType.lesson) {
                      widget.context.read<Lessons2Cubit>().loadMoreLessonsPage(
                          widget.data?[index].course?.id ?? 0);
                    } else if (widget.type == ItemType.homework) {
                      widget.context
                          .read<HomeworksCubit>()
                          .loadMoreHomeworksPage(
                              widget.data?[index].lesson?.id ?? 0,
                              isStudentDetails: widget.isStudentDetails);
                    } else if (widget.type == ItemType.exam) {
                      widget.context.read<TestsCubit>().loadMoreTestsPage(
                          widget.data?[index].lesson?.id ?? 0,
                          isStudentDetails: widget.isStudentDetails);
                    }
                  }
                  if (widget.type == ItemType.exam &&
                      widget.currentExamId != null &&
                      (widget.data ?? []).isNotEmpty)
                    widget.currentExamId!(widget.data?[index].exam?.id);
                },
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: widget.showShimmer
                      ? _shimmerItem()
                      : _item((widget.data ?? [])[index]),
                ),
                itemCount: widget.showShimmer ? 5 : widget.data?.length ?? 0,
              )
            : _errorItem(),
        if (widget.errorMessage == null) _indicator(),
        if (widget.showAddButton ??
            instance<AppPreferences>().getUserType() == 'teacher')
          SizedBox(
            height: 15.h,
          ),
        if (widget.showAddButton ??
            instance<AppPreferences>().getUserType() == "teacher")
          Center(
            child: DefaultButtonWidget(
              onPressed: () {
                if (widget.type == ItemType.exam) {
                  AppFunctions.navigateTo(
                      context,
                      AddExamView(
                        lessonId: widget.data?[0].lesson?.id ?? 0,
                        examsContext: widget.context,
                      ));
                } else if (widget.type == ItemType.homework) {
                  AppFunctions.navigateTo(
                      context,
                      AddHomeworkView(
                        lessonId: widget.data?[0].lesson?.id ?? 0,
                        homeworksContext: widget.context,
                      ));
                } else if (widget.type == ItemType.course) {
                  AppFunctions.navigateTo(
                      context,
                      AddCourseView(
                        coursesContext: widget.context,
                      ));
                } else {
                  AppFunctions.navigateTo(
                      context,
                      AddLessonView(
                        courseId: widget.data?[0].course?.id ?? 0,
                        lessonsContext: widget.context,
                      ));
                }
              },
              text: widget.type == ItemType.exam
                  ? AppStrings.addExam.tr()
                  : widget.type == ItemType.homework
                      ? AppStrings.addHomework.tr()
                      : widget.type == ItemType.course
                          ? AppStrings.addCourse.tr()
                          : AppStrings.addLesson.tr(),
              textColor: ColorManager.white,
              color: ColorManager.primary,
              isExpanded: false,
              horizontalPadding: 50.w,
              fontSize: 13.r,
            ),
          ),
      ],
    );
  }

  _indicator() {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                margin: EdgeInsets.only(bottom: 5.h, top: 10.h),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: ColorManager.lightGrey),
                child: SmoothPageIndicator(
                  controller: _coursesController,
                  effect: ExpandingDotsEffect(
                    dotColor: ColorManager.white,
                    dotHeight: 8.w,
                    dotWidth: 8.w,
                    spacing: 5.0.w,
                    expansionFactor: 2.w,
                    activeDotColor: ColorManager.primary,
                  ),
                  count: widget.data?.length ?? 10,
                ),
              ),
              if (widget.state?.isLoadingMore ?? false) ...[
                SizedBox(
                  width: 15.w,
                ),
                Text(
                  AppStrings.loadMore.tr(),
                  style: getSemiBoldStyle(
                      fontSize: 13.sp, color: ColorManager.blackText),
                ),
                SizedBox(
                  width: 10.w,
                ),
                SizedBox(
                    height: 15.h,
                    width: 15.w,
                    child: const Center(child: CircularProgressIndicator()))
              ],
            ],
          ),
        ),
      ),
    );
  }

  _item(CourseOrLessonOrExamOrHomeworkModel? model) {
    return InkWell(
      borderRadius: BorderRadius.circular(10.r),
      onTap: () {
        if (widget.type == ItemType.lesson) {
          if (instance<AppPreferences>().getUserType() != "parent") {
            if (instance<AppPreferences>().getToken().isNotEmpty) {
              AppFunctions.navigateTo(
                  context, LessonDetailsView(id: model?.lesson?.id ?? 0));
            } else {
              AppFunctions.showMyDialog(
                context,
                title: AppStrings.loginFirst.tr(),
                confirmButtonText: AppStrings.login.tr(),
                onConfirm: () {
                  AppFunctions.navigateTo(context, const LoginView());
                },
              );
            }
          }
        } else if (widget.type == ItemType.course) {
          AppFunctions.navigateTo(
              context,
              DetailsView(
                detailsType: DetailsType.course,
                id: model?.course?.id ?? 0,
              ));
        } else if (widget.type == ItemType.homework) {
          AppFunctions.navigateTo(
              context, HomeworkDetailsView(homeworkModel: model!.homework!));
        } else if (widget.type == ItemType.exam) {
          AppFunctions.navigateTo(
              context,
              ExamDetailsView(
                examId: model?.exam?.id ?? 0,
                lessonId: model?.lesson?.id ?? 0,
                examsContext: widget.context,
              ));
        }
      },
      child: Container(
        padding: EdgeInsets.only(bottom: 5.h),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: ColorManager.greyBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _image(model),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          _getName(model),
                          style: getSemiBoldStyle(
                              fontSize: 14.sp,
                              color: ColorManager.greyTextColor),
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      if (widget.type == ItemType.course)
                        Text(
                          "${model?.course?.price ?? '0'} ${AppStrings.pound.tr()}",
                          style: getSemiBoldStyle(
                              fontSize: 14.sp, color: ColorManager.primary),
                        ),
                    ],
                  ),
                  if (widget.type == ItemType.exam)
                    _timeAndQuestionsCount(model?.exam),
                  Divider(
                    height: 30.h,
                    color: ColorManager.lightGrey2,
                  ),
                  if (widget.type == ItemType.homework ||
                      widget.type == ItemType.exam ||
                      instance<AppPreferences>().getUserType() != "teacher")
                    if (widget.type == ItemType.exam &&
                        model?.exam?.studentSubmission != null)
                      InkWell(
                        onTap: () {
                          AppFunctions.navigateTo(
                            context,
                            ExamSubmissionDetailsView(
                              examId: model?.exam?.id ?? 0,
                              submissionId:
                                  model?.exam?.studentSubmission?.id ?? 0,
                            ),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                      "${AppStrings.submittedAt.tr()} : ${model?.exam?.studentSubmission?.submittedAt}\n${AppStrings.score.tr()} : ${model?.exam?.studentSubmission?.score}\t\t\t${AppStrings.duration.tr()} : ${model?.exam?.studentSubmission?.duration}",
                                      style: getMediumStyle(
                                          fontSize: 13.sp,
                                          color: ColorManager.blackText,
                                          height: 2.h))),
                              SizedBox(
                                width: 10.w,
                              ),
                              Icon(
                                Icons.arrow_forward_rounded,
                                color: ColorManager.primary,
                                size: 20.r,
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Center(
                          child: Text(
                        instance<AppPreferences>().getUserType() == "teacher" ||
                                widget.type == ItemType.homework
                            ? AppStrings.view.tr()
                            : AppStrings.begin.tr(),
                        style: getSemiBoldStyle(
                            fontSize: 17.sp, color: ColorManager.black),
                        textAlign: TextAlign.center,
                      ))
                  else
                    Row(
                      children: [
                        SizedBox(
                          width: 10.w,
                        ),
                        Text(
                          widget.type == ItemType.exam
                              ? AppStrings.begin.tr()
                              : AppStrings.view.tr(),
                          style: getSemiBoldStyle(
                              fontSize: 17.sp, color: ColorManager.black),
                          textAlign: TextAlign.center,
                        ),
                        const Spacer(),
                        BlocBuilder<DeleteActiveCourseOrLessonCubit,
                            BaseState<String>>(
                          builder: (context, state) {
                            return Switch(
                              value: widget.type == ItemType.course
                                  ? (model?.course?.status == 1)
                                  : (model?.lesson?.status == 1),
                              onChanged: (_) {
                                // setState((){
                                //   if(model?.course?.status == 1){
                                //     model?.course?.status = 0;
                                //   }else{
                                //     model?.course?.status = 1;
                                //   }
                                // });
                                _isDelete = false;
                                _deleteActiveCourseOrLessonCubit
                                    .deleteActiveCourseOrLesson(
                                  id: widget.type == ItemType.course
                                      ? model?.course?.id ?? 0
                                      : widget.type == ItemType.lesson
                                          ? model?.lesson?.id ?? 0
                                          : model?.homework?.id ?? 0,
                                  type: widget.type,
                                  isDelete: false,
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _image(CourseOrLessonOrExamOrHomeworkModel? model) {
    return Stack(
      alignment: AlignmentDirectional.topStart,
      children: [
        DefaultImageWidget(
          height: MediaQuery.sizeOf(context).height * .25,
          image: _getImage(model),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: Row(
            children: [
              if (widget.type == ItemType.course)
                Container(
                  margin: EdgeInsetsDirectional.fromSTEB(10.w, 0, 0, 0),
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.r),
                      color: ColorManager.black),
                  child: Text(
                    model?.course?.subject ?? '',
                    style: getSemiBoldStyle(
                        fontSize: 13.sp, color: ColorManager.white),
                  ),
                ),
              if (instance<AppPreferences>().getUserType() == "teacher") ...[
                const Spacer(),
                BlocBuilder<DeleteActiveCourseOrLessonCubit, BaseState<String>>(
                  builder: (context, state) {
                    _deleteActiveCourseOrLessonCubit =
                        context.read<DeleteActiveCourseOrLessonCubit>();
                    return DefaultButtonWidget(
                      isIcon: true,
                      isText: false,
                      isLoading: state.status == Status.loading && _isDelete,
                      color: ColorManager.red,
                      iconBuilder: Icon(
                        Icons.delete,
                        color: ColorManager.white,
                        size: 20.r,
                      ),
                      onPressed: () {
                        _isDelete = true;
                        _deleteActiveCourseOrLessonCubit
                            .deleteActiveCourseOrLesson(
                          id: widget.type == ItemType.course
                              ? model?.course?.id ?? 0
                              : widget.type == ItemType.lesson
                                  ? model?.lesson?.id ?? 0
                                  : widget.type == ItemType.homework
                                      ? model?.homework?.id ?? 0
                                      : model?.exam?.id ?? 0,
                          type: widget.type,
                          isDelete: true,
                        );
                      },
                    );
                  },
                ),
                SizedBox(
                  width: 10.w,
                ),
                if (!(widget.type == ItemType.homework ||
                    (widget.type == ItemType.exam &&
                        model?.exam?.isAdminCreated == 1)))
                  DefaultButtonWidget(
                    isIcon: true,
                    isText: false,
                    color: ColorManager.yellow,
                    iconBuilder: Icon(
                      Icons.edit,
                      color: ColorManager.white,
                      size: 20.r,
                    ),
                    onPressed: () {
                      if (widget.type == ItemType.course) {
                        AppFunctions.navigateTo(
                            context,
                            AddCourseView(
                              course: model?.course,
                              coursesContext: widget.context,
                            ));
                      } else if (widget.type == ItemType.lesson) {
                        AppFunctions.navigateTo(
                            context,
                            AddLessonView(
                              lesson: model?.lesson,
                              courseId: model?.course?.id ?? 0,
                              lessonsContext: widget.context,
                            ));
                      } else if (widget.type == ItemType.exam) {
                        AppFunctions.navigateTo(
                            context,
                            AddExamView(
                              exam: model?.exam,
                              lessonId: model?.lesson?.id ?? 0,
                              examsContext: widget.context,
                            ));
                      }
                    },
                  ),
                SizedBox(
                  width: 10.w,
                ),
              ]
            ],
          ),
        ),
      ],
    );
  }

  _timeAndQuestionsCount(ExamModel? test) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10.w, 15.h, 10.w, 5.h),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                SvgPicture.asset(IconAssets.clock, height: 5.w, width: 5.w),
                SizedBox(
                  width: 10.w,
                ),
                Text(
                  "${test?.duration ?? 0} ${AppStrings.minutes.tr()}",
                  style: getRegularStyle(
                      fontSize: 12.sp, color: ColorManager.blackText),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          Expanded(
            child: Row(
              children: [
                SvgPicture.asset(IconAssets.cap, height: 5.w, width: 5.w),
                SizedBox(
                  width: 10.w,
                ),
                Text(
                  "${test?.counts ?? 0} ${AppStrings.questions.tr()}",
                  style: getRegularStyle(
                      fontSize: 12.sp, color: ColorManager.blackText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _shimmerItem() {
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: ColorManager.greyBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: AlignmentDirectional.topStart,
            children: [
              ShimmerContainerWidget(
                height: MediaQuery.sizeOf(context).height * .23,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 0),
                child: Row(
                  children: [
                    ShimmerContainerWidget(
                      height: 30.h,
                      width: 100.w,
                    ),
                    const Spacer(),
                    ShimmerContainerWidget(
                      height: 30.h,
                      width: 30.w,
                      radios: 20.r,
                    ),
                    SizedBox(
                      width: 15.w,
                    ),
                    ShimmerContainerWidget(
                      height: 30.h,
                      width: 30.w,
                      radios: 20.r,
                    ),
                  ],
                ),
              ),
            ],
          ),
          // SizedBox(
          //   height: 10.h,
          // ),
          // ShimmerContainerWidget(
          //   height: 30.h,
          //   width: 150.w,
          // ),
          SizedBox(
            height: 10.h,
          ),
          ShimmerContainerWidget(height: 30.h),
          Divider(
            height: 30.h,
            color: ColorManager.lightGrey2,
          ),
          Row(
            children: [
              ShimmerContainerWidget(
                height: 30.h,
                width: 100.w,
              ),
              const Spacer(),
              ShimmerContainerWidget(
                height: 30.h,
                width: 100.w,
                radios: 20.r,
              ),
            ],
          ),
        ],
      ),
    );
  }

  _errorItem() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 50.h),
      margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      color: ColorManager.white,
      child: DefaultErrorWidget(errorMessage: widget.errorMessage ?? ''),
    );
  }

  String _getImage(CourseOrLessonOrExamOrHomeworkModel? model) {
    switch (widget.type) {
      case ItemType.course:
        return model?.course?.image ?? '';
      case ItemType.lesson:
        return model?.lesson?.image ?? '';
      case ItemType.exam:
        return model?.exam?.image ?? '';
      case ItemType.homework:
        return model?.homework?.image ?? '';
    }
  }

  String _getName(CourseOrLessonOrExamOrHomeworkModel? model) {
    switch (widget.type) {
      case ItemType.course:
        return model?.course?.name ?? '';
      case ItemType.lesson:
        return model?.lesson?.name ?? '';
      case ItemType.exam:
        return model?.exam?.name ?? '';
      case ItemType.homework:
        return model?.homework?.name ?? '';
    }
  }
}
