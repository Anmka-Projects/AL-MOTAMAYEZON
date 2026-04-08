import 'package:elmotamizon/app/app_functions.dart';
import 'package:elmotamizon/app/imports.dart';
import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/common/widgets/default_app_bar.dart';
import 'package:elmotamizon/common/widgets/default_button_widget.dart';
import 'package:elmotamizon/common/widgets/default_dropdown_menu_widget.dart';
import 'package:elmotamizon/common/widgets/default_form_field.dart';
import 'package:elmotamizon/common/widgets/default_pick_files_widget.dart';
import 'package:elmotamizon/features/add_course/cubit/add_course/add_course_cubit.dart';
import 'package:elmotamizon/features/add_course/cubit/subjects/subjects_cubit.dart';
import 'package:elmotamizon/features/add_course/models/subjects_model.dart';
import 'package:elmotamizon/features/auth/signup/cubit/stages_grades_cubit/stages_grades_cubit.dart';
import 'package:elmotamizon/features/auth/signup/models/stages_grades_model.dart';
import 'package:elmotamizon/features/details/models/course_details_model.dart';
import 'package:elmotamizon/features/teacher_parent_home/cubit/courses/courses_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddCourseView extends StatefulWidget {
  final CourseModel? course;
  final BuildContext coursesContext;
  const AddCourseView({super.key, this.course, required this.coursesContext});

  @override
  State<AddCourseView> createState() => _AddCourseViewState();
}

class _AddCourseViewState extends State<AddCourseView> {
  final TextEditingController _nameArController = TextEditingController();
  final TextEditingController _nameEnController = TextEditingController();
  final TextEditingController _videoController = TextEditingController();
  final TextEditingController _descriptionArController = TextEditingController();
  final TextEditingController _descriptionEnController = TextEditingController();
  final TextEditingController _whatYouLearnArController = TextEditingController();
  final TextEditingController _whatYouLearnEnController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String? _selectedImagePath;
  SubjectModel? _selectedSubject;

  @override
  void initState() {
    super.initState();
    if(widget.course != null){
      _nameArController.text = widget.course!.nameAr??'';
      _nameEnController.text = widget.course!.nameEn??'';
      _videoController.text = widget.course!.videoUrl??'';
      _descriptionArController.text = widget.course!.descriptionAr??'';
      _descriptionEnController.text = widget.course!.descriptionEn??'';
      _whatYouLearnArController.text = widget.course!.whatYouWillLearnAr??'';
      _whatYouLearnEnController.text = widget.course!.whatYouWillLearnEn??'';
      _priceController.text = (widget.course!.price??0).toString();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameArController.dispose();
    _nameEnController.dispose();
    _videoController.dispose();
    _descriptionArController.dispose();
    _descriptionEnController.dispose();
    _whatYouLearnArController.dispose();
    _whatYouLearnEnController.dispose();
    _priceController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => instance<AddCourseCubit>(),
      child: Scaffold(
        appBar: DefaultAppBar(text: AppStrings.addCourse.tr(),),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            child: Column(
              children: [
                DefaultFormField(
                  noBorder: false,
                  controller: _nameArController,
                  fillColor: ColorManager.fillColor,
                  borderColor: ColorManager.greyBorder,
                  hintText: AppStrings.courseNameAr.tr(),
                  title: AppStrings.courseNameAr.tr(),
                ),
                SizedBox(
                  height: 20.h,
                ),DefaultFormField(
                  noBorder: false,
                  controller: _nameEnController,
                  fillColor: ColorManager.fillColor,
                  borderColor: ColorManager.greyBorder,
                  hintText: AppStrings.courseNameEn.tr(),
                  title: AppStrings.courseNameEn.tr(),
                ),
                SizedBox(
                  height: 20.h,
                ),DefaultFormField(
                  noBorder: false,
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  fillColor: ColorManager.fillColor,
                  borderColor: ColorManager.greyBorder,
                  hintText: AppStrings.coursePrice.tr(),
                  title: AppStrings.coursePrice.tr(),
                ),
                SizedBox(
                  height: 20.h,
                ),
                _subjectsWidget(),
                SizedBox(
                  height: 20.h,
                ),
                _stagesGradesWidget(),
                SizedBox(
                  height: 20.h,
                ),
                StatefulBuilder(
                  builder: (context, setState) {
                    return DefaultPickFilesWidget(
                      imagesOnly: true,
                      isSingle: true,
                      remoteFiles: (widget.course?.image??'').isNotEmpty ? [widget.course?.image??''] : [],
                      title: AppStrings.coursePhoto.tr(),
                      onPicked: (filesPaths, filesNames) {
                        _selectedImagePath = filesPaths.first;
                      },
                      clear: _selectedImagePath == null,
                    );
                  }
                ),
                SizedBox(
                  height: 20.h,
                ),
                DefaultFormField(
                  noBorder: false,
                  controller: _videoController,
                  fillColor: ColorManager.fillColor,
                  borderColor: ColorManager.greyBorder,
                  hintText: AppStrings.videoLink.tr(),
                  title: AppStrings.courseVideoPresentation.tr(),
                ),
                SizedBox(
                  height: 20.h,
                ),
                DefaultFormField(
                  maxLines: 5,
                  noBorder: false,
                  controller: _descriptionArController,
                  fillColor: ColorManager.fillColor,
                  borderColor: ColorManager.greyBorder,
                  hintText: AppStrings.descriptionAr.tr(),
                  title: AppStrings.courseDescriptionAr.tr(),
                ),
                SizedBox(
                  height: 20.h,
                ),
                DefaultFormField(
                  maxLines: 5,
                  noBorder: false,
                  controller: _descriptionEnController,
                  fillColor: ColorManager.fillColor,
                  borderColor: ColorManager.greyBorder,
                  hintText: AppStrings.descriptionEn.tr(),
                  title: AppStrings.courseDescriptionEn.tr(),
                ), SizedBox(
                  height: 20.h,
                ),
                DefaultFormField(
                  maxLines: 5,
                  noBorder: false,
                  controller: _whatYouLearnArController,
                  fillColor: ColorManager.fillColor,
                  borderColor: ColorManager.greyBorder,
                  hintText: AppStrings.descriptionAr.tr(),
                  title: AppStrings.whatYouLearnInThisCourseAr.tr(),
                ),
                SizedBox(
                  height: 20.h,
                ),
                DefaultFormField(
                  maxLines: 5,
                  noBorder: false,
                  controller: _whatYouLearnEnController,
                  fillColor: ColorManager.fillColor,
                  borderColor: ColorManager.greyBorder,
                  hintText: AppStrings.descriptionEn.tr(),
                  title: AppStrings.whatYouLearnInThisCourseEn.tr(),
                ),
                SizedBox(
                  height: 20.h,
                ),
                BlocConsumer<AddCourseCubit, BaseState<String>>(
                  listener: (context, state) {
                    if (state.status == Status.success) {
                      AppFunctions.showsToast(state.data ?? '', ColorManager.successGreen, context);
                      widget.coursesContext.read<CoursesCubit>().loadFirstCoursesPage();
                      // instance<CoursesCubit>().loadFirstCoursesPage();
                      Navigator.pop(context);
                    }else if (state.status == Status.failure) {
                      AppFunctions.showsToast(state.errorMessage ?? '', ColorManager.red, context);
                    }
                  },
                  builder: (context, state) {
                    return DefaultButtonWidget(
                      onPressed: () {
                        context.read<AddCourseCubit>().addCourse(
                          price: _priceController.text,
                          nameAr: _nameArController.text, nameEn: _nameArController.text, descriptionAr: _descriptionArController.text, descriptionEn: _descriptionArController.text,
                          whatYouWillLearnAr: _whatYouLearnArController.text, whatYouWillLearnEn: _whatYouLearnArController.text, subjectId: (_selectedSubject?.id ?? 0).toString(),
                          imagePath: _selectedImagePath ?? '', videoUrl: _videoController.text,courseId: widget.course?.id, gradeId: _selectedGrade?.id.toString() ?? '', stageId: _selectedStage?.id.toString() ?? ''
                        );
                      },
                      text: widget.course != null ? AppStrings.save.tr() : AppStrings.addCourse.tr(),
                      textColor: ColorManager.white,
                      color: ColorManager.primary,
                      horizontalPadding: 30.w,
                      fontSize: 13.r,
                      isLoading: state.status == Status.loading,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _subjectsWidget() {
    return BlocProvider(
      create: (context) => instance<SubjectsCubit>()..getSubjects(),
      child: BlocConsumer<SubjectsCubit, BaseState<SubjectsModel>>(
        listener: (context, state) {
          if(widget.course != null) {
            if (state.status == Status.success) {
              if ((state.data?.data ?? []).isNotEmpty) {
                _selectedSubject = state.data?.data.firstWhere(
                  (element) => element.id == widget.course?.subjectId,
                );
              }
            }
          }
        },
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          if (state.status == Status.loading || state.status == Status.initial) {
            return const Center(child: CircularProgressIndicator());
          }
          else if (state.status == Status.success) {
            return StatefulBuilder(
                builder: (context,setState) {
                  return DefaultDropdownMenuWidget<SubjectModel>(
                    onSelected: (value) {
                      setState(() {
                        _selectedSubject = value;
                      });
                    },
                    items: state.data?.data??[],
                    hintText: AppStrings.selectStage.tr(),
                    selectedValue: _selectedSubject,
                    title: AppStrings.courseType.tr(),
                    optionTitle: (item) => item?.name ?? '',
                    searchOptionTitle: (item) => item?.name ?? '',
                  );
                }
            );
          }
          else{
            return InkWell(
              onTap: () => context.read<SubjectsCubit>().getSubjects(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(child: Text(state.errorMessage!)),
                  SizedBox(width: 5.w,),
                  const Icon(Icons.refresh,color: ColorManager.primary,),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  StageModel? _selectedStage;
  GradeModel? _selectedGrade;

  _stagesGradesWidget() {
    return BlocProvider(
      create: (context) => instance<StagesGradesCubit>()..getStagesGrades(),
      child: BlocConsumer<StagesGradesCubit, BaseState<StagesGradesModel>>(
        listener: (context, state) {
          if(widget.course != null) {
            if (state.status == Status.success) {
              if ((state.data?.data?.stages ?? []).isNotEmpty && widget.course?.stageId != null) {
                _selectedStage = state.data?.data?.stages?.firstWhere(
                      (element) => element.id == widget.course?.stageId,
                );
                if((_selectedStage?.grades??[]).isNotEmpty) {
                  _selectedGrade = _selectedStage?.grades?.firstWhere(
                      (element) => element.id == widget.course?.gradeId,
                );
                }
              }
            }
          }
        },
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          if (state.status == Status.loading || state.status == Status.initial) {
            return const Center(child: CircularProgressIndicator());
          }
          else if (state.status == Status.success) {
            return StatefulBuilder(
                builder: (context,setState) {
                  return Column(
                    children: [
                      DefaultDropdownMenuWidget<StageModel>(
                        onSelected: (value) {
                          setState(() {
                            _selectedStage = value;
                            if(_selectedGrade != null) _selectedGrade = null;
                          });
                        },
                        items: state.data?.data?.stages??[],
                        hintText: AppStrings.selectStage.tr(),
                        selectedValue: _selectedStage,
                        title: AppStrings.stage.tr(),
                        optionTitle: (item) => item?.name ?? '',
                        searchOptionTitle: (item) => item?.name ?? '',
                      ),
                      if(_selectedStage != null)
                        SizedBox(
                          height: 15.h,
                        ),
                      if(_selectedStage != null)
                        DefaultDropdownMenuWidget<GradeModel>(
                          onSelected: (value) {
                            setState(() {
                              _selectedGrade = value;
                            });
                          },
                          items:_selectedStage?.grades??[],
                          title: AppStrings.grade.tr(),
                          hintText: AppStrings.selectGrade.tr(),
                          selectedValue: _selectedGrade,
                          optionTitle: (item) => item?.name ?? '',
                          searchOptionTitle: (item) => item?.name ?? '',
                        ),
                    ],
                  );
                }
            );
          }
          else{
            return InkWell(
              onTap: () => context.read<StagesGradesCubit>().getStagesGrades(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(child: Text(state.errorMessage!)),
                  SizedBox(width: 5.w,),
                  const Icon(Icons.refresh,color: ColorManager.primary,),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
