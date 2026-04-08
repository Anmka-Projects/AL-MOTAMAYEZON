import 'package:elmotamizon/app/app_functions.dart';
import 'package:elmotamizon/app/imports.dart';
import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/common/resources/styles_manager.dart';
import 'package:elmotamizon/common/widgets/default_app_bar.dart';
import 'package:elmotamizon/common/widgets/default_button_widget.dart';
import 'package:elmotamizon/common/widgets/default_form_field.dart';
import 'package:elmotamizon/common/widgets/default_pick_files_widget.dart';
import 'package:elmotamizon/common/widgets/default_radio_button.dart';
import 'package:elmotamizon/features/add_exam/cubit/add_exam_cubit.dart';
import 'package:elmotamizon/features/add_exam/cubit/system_exams_cubit.dart';
import 'package:elmotamizon/features/add_exam/view/widgets/questions_widget.dart';
import 'package:elmotamizon/features/details/models/course_or_lesson_or_exam_or_homework_model.dart';
import 'package:elmotamizon/features/details/view/widgets/course_or_lesson_or_exam_or_homework_widget.dart';
import 'package:elmotamizon/features/exam_details/models/exam_details_model.dart';
import 'package:elmotamizon/features/lesson_details/cubit/tests_cubit/tests_cubit.dart';
import 'package:elmotamizon/features/lesson_details/models/lesson_details_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddExamView extends StatefulWidget {
  final ExamModel? exam;
  final int lessonId;
  final BuildContext examsContext;
  const AddExamView(
      {super.key,
      this.exam,
      required this.lessonId,
      required this.examsContext});

  @override
  State<AddExamView> createState() => _AddExamViewState();
}

class _AddExamViewState extends State<AddExamView> {
  final PageController _pageController = PageController();
  final TextEditingController _nameArController = TextEditingController();
  final TextEditingController _nameEnController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedImagePath;
  int? _selectedExamIdFromResource;
  int _selectedId = 1;

  @override
  void initState() {
    super.initState();
    if (widget.exam != null) {
      _nameArController.text = widget.exam?.nameAr ?? '';
      _nameEnController.text = widget.exam?.nameEn ?? '';
      _nameEnController.text = widget.exam?.nameEn ?? '';
      _durationController.text = (widget.exam?.duration ?? 0).toString();
      _descriptionController.text = widget.exam?.description ?? '';
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameArController.dispose();
    _nameEnController.dispose();
    _durationController.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddExamCubit>(
        create: (context) => instance<AddExamCubit>(),
        child: Scaffold(
          appBar: DefaultAppBar(
            text: widget.exam == null
                ? AppStrings.addExam.tr()
                : AppStrings.editExam.tr(),
          ),
          body: Column(children: [
            _radioButtonWidget(),
            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                children: [
                  _newBody(),
                  _existFromResourcesBody(),
                ],
              ),
            ),
          ]),
        ));
  }

  _radioButtonWidget() {
    return StatefulBuilder(builder: (context, setState) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            child: DefaultRadioButton(
              titleStyle: getSemiBoldStyle(
                  fontSize: 13.sp, color: ColorManager.textColor),
              selected: _selectedId == 1,
              title: AppStrings.NEW.tr(),
              isExpanded: false,
              onTap: () {
                setState(() {
                  _selectedId = 1;
                });
                _pageController.animateToPage(0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.linear);
              },
              fillRadios: 12.r,
            ),
          ),
          Flexible(
            child: DefaultRadioButton(
              fillRadios: 12.r,
              titleStyle: getSemiBoldStyle(
                  fontSize: 13.sp, color: ColorManager.textColor),
              isExpanded: false,
              selected: _selectedId == 2,
              title: AppStrings.existFromResources.tr(),
              onTap: () {
                setState(() {
                  _selectedId = 2;
                });
                _pageController.animateToPage(1,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.linear);
              },
            ),
          ),
        ],
      );
    });
  }

  _newBody() {
    return ListView(
      padding: EdgeInsets.fromLTRB(15.w, 0, 15.h, 15.h),
      children: [
        DefaultFormField(
          noBorder: false,
          controller: _nameArController,
          fillColor: ColorManager.fillColor,
          borderColor: ColorManager.greyBorder,
          hintText: AppStrings.examNameAr.tr(),
          title: AppStrings.examNameAr.tr(),
        ),
        SizedBox(
          height: 20.h,
        ),
        DefaultFormField(
          noBorder: false,
          controller: _nameEnController,
          fillColor: ColorManager.fillColor,
          borderColor: ColorManager.greyBorder,
          hintText: AppStrings.examNameEn.tr(),
          title: AppStrings.examNameEn.tr(),
        ),
        SizedBox(
          height: 20.h,
        ),
        DefaultFormField(
          noBorder: false,
          controller: _descriptionController,
          fillColor: ColorManager.fillColor,
          borderColor: ColorManager.greyBorder,
          hintText: AppStrings.description.tr(),
          title: AppStrings.description.tr(),
          maxLines: 3,
        ),
        SizedBox(
          height: 20.h,
        ),
        DefaultPickFilesWidget(
          imagesOnly: true,
          isSingle: true,
          title: AppStrings.examPhoto.tr(),
          onPicked: (filesPaths, filesNames) {
            _selectedImagePath = filesPaths.first;
          },
          clear: _selectedImagePath == '',
          remoteFiles: (widget.exam?.image ?? '').isEmpty
              ? []
              : [widget.exam?.image ?? ''],
        ),
        SizedBox(
          height: 20.h,
        ),
        DefaultFormField(
          controller: _durationController,
          noBorder: false,
          fillColor: ColorManager.fillColor,
          borderColor: ColorManager.greyBorder,
          hintText: AppStrings.duration.tr(),
          title: AppStrings.duration.tr(),
        ),
        SizedBox(
          height: 20.h,
        ),
        QuestionsWidget(
          lessonId: widget.lessonId,
          questions: widget.exam?.questions,
        ),
        _addButton(),
      ],
    );
  }

  _existFromResourcesBody() {
    return Column(
      children: [
        BlocProvider(
          create: (context) => instance<SystemExamsCubit>()
            ..loadFirstSystemExamsPage(widget.lessonId),
          child: BlocBuilder<SystemExamsCubit, BaseState<ExamModel>>(
            builder: (context, state) {
              return CourseOrLessonOrExamOrHomeWorkWidget(
                data: state.items.isEmpty
                    ? [
                        CourseOrLessonOrExamOrHomeworkModel(
                          lesson: Lesson2Model(id: widget.lessonId),
                        ),
                      ]
                    : state.items
                        .map(
                          (e) => CourseOrLessonOrExamOrHomeworkModel(
                              lesson: Lesson2Model(id: widget.lessonId),
                              exam: e),
                        )
                        .toList(),
                type: ItemType.exam,
                title: AppStrings.exams.tr(),
                state: state,
                showShimmer: state.status == Status.loading,
                errorMessage: state.errorMessage,
                showAddButton: false,
                currentExamId: (currentExamId) {
                  _selectedExamIdFromResource = currentExamId;
                },
                context: context,
              );
            },
          ),
        ),
        SizedBox(
          height: 15.h,
        ),
        _addButton(),
      ],
    );
  }

  _addButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: BlocConsumer<AddExamCubit, BaseState<String>>(
        listener: (context, state) {
          if (state.status == Status.success) {
            AppFunctions.showsToast(
                state.data ?? '', ColorManager.successGreen, context);
            widget.examsContext
                .read<TestsCubit>()
                .loadFirstTestsPage(widget.lessonId);
            Navigator.pop(context);
          } else if (state.status == Status.failure) {
            AppFunctions.showsToast(
                state.errorMessage ?? '', ColorManager.red, context);
          }
        },
        builder: (context, state) {
          return DefaultButtonWidget(
            onPressed: () {
              context.read<AddExamCubit>().addExam(
                    nameAr: _nameArController.text,
                    nameEn: _nameEnController.text,
                    lessonId: widget.lessonId,
                    duration: _durationController.text,
                    imagePath: _selectedImagePath ?? '',
                    examId: widget.exam?.id,
                    description: _descriptionController.text,
                    resourceExamId: _selectedExamIdFromResource,
                  );
            },
            text: widget.exam != null
                ? AppStrings.save.tr()
                : AppStrings.addExam.tr(),
            textColor: ColorManager.white,
            color: ColorManager.primary,
            isExpanded: false,
            horizontalPadding: 30.w,
            isLoading: state.status == Status.loading,
            fontSize: 13.r,
          );
        },
      ),
    );
  }
}
