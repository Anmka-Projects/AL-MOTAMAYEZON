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
import 'package:elmotamizon/common/widgets/default_expansion_tile.dart';
import 'package:elmotamizon/common/widgets/default_image_widget.dart';
import 'package:elmotamizon/common/widgets/default_pick_files_widget.dart';
import 'package:elmotamizon/common/widgets/download_file_widget.dart';
import 'package:elmotamizon/features/details/view/widgets/header_image_widget.dart';
import 'package:elmotamizon/features/homework_details/cubit/submit_homework_cubit.dart';
import 'package:elmotamizon/features/homework_details/cubit/submissions_homeworks_cubit.dart';
import 'package:elmotamizon/features/lesson_details/models/homeworks_model.dart';
import 'package:elmotamizon/features/homework_details/models/submissions_homeworks.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elmotamizon/features/homework_details/cubit/grade_submission_cubit.dart';

class HomeworkDetailsView extends StatefulWidget {
  final HomeworkModel homeworkModel;
  const HomeworkDetailsView({super.key, required this.homeworkModel});

  @override
  State<HomeworkDetailsView> createState() => _HomeworkDetailsViewState();
}

class _HomeworkDetailsViewState extends State<HomeworkDetailsView> {
  final List<String> _files = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.bg,
      body: Column(
        children: [
          HeaderImageWidget(image: widget.homeworkModel.image??'', name: widget.homeworkModel.name??''),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(bottom: 20.h),
              children: [
                _body(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _body() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   AppStrings.homeworkPhoto.tr(),
          //   style: getBoldStyle(fontSize: 14.sp, color: ColorManager.blackText),
          // ),
          // SizedBox(
          //   height: 10.h,
          // ),
          // const DefaultImageWidget(image: "https://strippedfilm.com/wp-content/uploads/2024/01/homeworkify-1.jpg"),
          SizedBox(height: 10.h),
          Text(
            AppStrings.resources.tr(),
            style: getBoldStyle(fontSize: 14.sp, color: ColorManager.blackText),
          ),
          SizedBox(
            height: 10.h,
          ),
          _resources(),
          if(instance<AppPreferences>().getUserType() == "student")
          _uploadYourAnswer(),
          // if(instance<AppPreferences>().getUserType() == "teacher")
            ...[
              SizedBox(height: 10.h),
              Text(AppStrings.submissions.tr(), style: getBoldStyle(fontSize: 14.sp, color: ColorManager.blackText)),
              const Divider(),
              // SizedBox(height: 10.h),
              _submissions(),
            ],
        ],
      ),
    );
  }

  _resources() {
    return DefaultExpansionTile(
        name: AppStrings.homeworkFiles.tr(),
        initiallyExpanded: true,
        optionsWidget: List.generate(
          widget.homeworkModel.files.length,
              (index) => DownloadFileWidget(url: widget.homeworkModel.files[index].file??'', fileName: (widget.homeworkModel.files[index].file??'').split("/").last),
        ));
  }

  _uploadYourAnswer(){
    return BlocProvider(
      create: (context) => instance<SubmitHomeworkCubit>(),
  child: BlocConsumer<SubmitHomeworkCubit, BaseState<String>>(
    listener: (context, state) {
      if (state.status == Status.success) {
        AppFunctions.showsToast(state.data ?? '', ColorManager.successGreen, context);
        instance<SubmissionsHomeworksCubit>().loadFirstSubmissionsHomeworksPage(widget.homeworkModel.id ?? 0);
        // instance<LessonsCubit>().loadFirstLessonsPage(widget.courseId);
      }else if(state.status == Status.failure){
        AppFunctions.showsToast(state.errorMessage ?? '', ColorManager.red, context);
      }
    },
  builder: (context, state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DefaultPickFilesWidget(
          onPicked: (filesPaths, filesNames) {
            _files.addAll(filesPaths);
          },
          onRemoveLocal: (index) {
            _files.removeAt(index);
          },
          title: AppStrings.uploadYourAnswer.tr(),
          clear: _files.isNotEmpty,
        ),
        // SizedBox(height: 10.h,),
        DefaultButtonWidget(
          onPressed: () {
            context.read<SubmitHomeworkCubit>().submitHomework(
              homeworkId: widget.homeworkModel.id??0,
              files: _files,
            );
          },
          text: AppStrings.submit.tr(),
          textColor: ColorManager.white,
          color: ColorManager.primary,
          verticalPadding: 10.h,
          fontSize: 14.sp,
          isLoading: state.status == Status.loading,
          isExpanded: true,
        ),
        // SizedBox(height: 10.h,),
        // DefaultButtonWidget(
        //   onPressed: () {
        //
        //   },
        //   text: AppStrings.alreadyGaveTheHomeworkOffline.tr(),
        //   withBorder: true,
        //   borderColor: ColorManager.primary,
        //   textColor: ColorManager.blackText,
        //   color: Colors.transparent,
        //   elevation: 0,
        //   verticalPadding: 10.h,
        //   fontSize: 10.sp,
        // ),
      ],
    );
  },
),
);
  }


  _submissions() {
    return BlocProvider.value(
      value: instance<SubmissionsHomeworksCubit>()..loadFirstSubmissionsHomeworksPage(widget.homeworkModel.id ?? 0),
      child: BlocBuilder<SubmissionsHomeworksCubit, BaseState<SubmissionHomeworkModel>>(
        builder: (context, state) {
          if (state.status == Status.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == Status.failure) {
            return DefaultErrorWidget(errorMessage: state.errorMessage ?? '', onPressed: () => context.read<SubmissionsHomeworksCubit>().loadFirstSubmissionsHomeworksPage(widget.homeworkModel.id ?? 0)); // يمكن تحسين الرسالة
          } else if (state.items.isEmpty) {
            return const Center(child: Text('لا يوجد تسليمات بعد'));
          }
          return ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 10.w),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.items.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final submission = state.items[index];
              return Card(
                color: ColorManager.white,
                elevation: 2,
                margin: EdgeInsets.symmetric(vertical: 8.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                child: Padding(
                  padding: EdgeInsets.all(15.0.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.person, color: ColorManager.primary),
                         SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              submission.studentName ?? '-',
                              style: getBoldStyle(fontSize: 15.sp, color: ColorManager.primary),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      if (submission.files.isNotEmpty) ...[
                        Text('${AppStrings.files.tr()}:', style: getBoldStyle(fontSize: 13.sp, color: ColorManager.blackText)),
                       // SizedBox(height: 6.h),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: state.items[index].files.map((file) => 
                          DownloadFileWidget(url: file.file??'', fileName: (file.file??'').split("/").last)).toList(),
                        ),
                        // const SizedBox(height: 10),
                      ],
                      Row(
                        children: [
                          const Icon(Icons.grade, color: ColorManager.successGreen, size: 20),
                          const SizedBox(width: 6),
                          Text('${AppStrings.degree.tr()}: ', style: getBoldStyle(fontSize: 13, color: ColorManager.textColor)),
                          Text(submission.grade ?? '-', style: getBoldStyle(fontSize: 13, color: ColorManager.textColor)),
                        ],
                      ),
                      const SizedBox(height: 15),
                      if (submission.note != null && submission.note!.isNotEmpty)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.sticky_note_2, color: ColorManager.primary, size: 20),
                            const SizedBox(width: 6),
                            Expanded(child: Text('${AppStrings.studentNote.tr()}: ${submission.note!}', style: getBoldStyle(fontSize: 12, color: ColorManager.textColor))),
                          ],
                        ),
                      if (submission.teacherNote != null && submission.teacherNote!.isNotEmpty)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.comment, color: ColorManager.primary, size: 20),
                            const SizedBox(width: 6),
                            Expanded(child: Text('${AppStrings.teacherNote.tr()}: ${submission.teacherNote!}', style: getBoldStyle(fontSize: 12, color: ColorManager.textColor))),
                          ],
                        ),
                      if (instance<AppPreferences>().getUserType() == "teacher")
                        Padding(
                          padding: EdgeInsets.only(top: 10.h),
                          child: BlocProvider(
                            create: (context) => instance<GradeSubmissionCubit>(),
                            child: BlocConsumer<GradeSubmissionCubit, GradeSubmissionState>(
                              listener: (context, state) {
                                if (state.status == Status.success) {
                                  AppFunctions.showsToast(state.message ?? 'تم التقييم بنجاح', ColorManager.successGreen, context);
                                  context.read<SubmissionsHomeworksCubit>().loadFirstSubmissionsHomeworksPage(widget.homeworkModel.id ?? 0);
                                } else if (state.status == Status.failure) {
                                  AppFunctions.showsToast(state.errorMessage ?? 'حدث خطأ', ColorManager.red, context);
                                }
                              },
                              builder: (context, state) {
                                return Builder(
                                  builder: (context) {
                                    return DefaultButtonWidget(
                                  onPressed: () => _showGradeDialog(context, submission.id ?? 0),
                                  text: submission.grade != null ? 'تعديل التقييم' : 'تقييم الواجب',
                                  color: submission.grade != null ? ColorManager.primary : ColorManager.successGreen,
                                  textColor: ColorManager.white,
                                  verticalPadding: 8.h,
                                  fontSize: 12.sp,
                                  isLoading: state.status == Status.loading,
                                );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showGradeDialog(BuildContext context, int submissionId) {
    final gradeController = TextEditingController();
    final noteController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: ColorManager.white,
        title: Text('تقييم الواجب', style: getBoldStyle(fontSize: 16.sp, color: ColorManager.primary)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: gradeController,
              decoration: const InputDecoration(
                labelText: 'الدرجة',
                hintText: 'أدخل الدرجة من 0 إلى 100',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 15.h),
            TextFormField(
              controller: noteController,
              decoration: const InputDecoration(
                labelText: 'ملاحظة المعلم (اختياري)',
                hintText: 'أدخل ملاحظتك للطالب',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: getBoldStyle(fontSize: 14.sp, color: ColorManager.grey)),
          ),
          DefaultButtonWidget(
            onPressed: () {
              final grade = int.tryParse(gradeController.text);
              if (grade != null && grade >= 0 && grade <= 100) {
                context.read<GradeSubmissionCubit>().gradeSubmission(
                  submissionId: submissionId,
                  grade: grade,
                  teacherNote: noteController.text.isNotEmpty ? noteController.text : null,
                );
                Navigator.pop(context);
              } else {
                AppFunctions.showsToast('الدرجة يجب أن تكون بين 0 و 100', ColorManager.red, context);
              }
            },
            text: AppStrings.save.tr(),
            color: ColorManager.primary,
            textColor: ColorManager.white,
            horizontalPadding: 15.w,
            isExpanded: false,
          ),
        ],
      ),
    );
  }
}