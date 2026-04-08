import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/styles_manager.dart';
import 'package:elmotamizon/common/widgets/default_app_bar.dart';
import 'package:elmotamizon/common/widgets/default_error_widget.dart';
import 'package:elmotamizon/features/exam_details/cubit/exam_submission_details_cubit.dart';
import 'package:elmotamizon/features/exam_details/models/exam_submission_details_model.dart';
import 'package:elmotamizon/common/base/base_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elmotamizon/app/imports.dart';

class ExamSubmissionDetailsView extends StatelessWidget {
  final int examId;
  final int submissionId;
  const ExamSubmissionDetailsView({super.key, required this.examId, required this.submissionId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => instance<ExamSubmissionDetailsCubit>()..getExamSubmissionDetails(submissionId: submissionId),
      child: Scaffold(
        appBar: DefaultAppBar(text: AppStrings.submissionDetails.tr(),backgroundColor: ColorManager.primary,titleColor: ColorManager.white,),
        backgroundColor: ColorManager.bg,
        body: BlocBuilder<ExamSubmissionDetailsCubit, BaseState<ExamSubmissionDetailsModel>>(
          builder: (context, state) {
            if (state.status == Status.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == Status.failure) {
              return DefaultErrorWidget(errorMessage: state.errorMessage ?? '');
            }
            final data = state.data;
            if (data == null) {
              return DefaultErrorWidget(errorMessage: AppStrings.noData.tr());
            }
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Material(
                    elevation: 3,
                    borderRadius: BorderRadius.circular(10.r),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
                      decoration: BoxDecoration(
                        color: ColorManager.white,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${AppStrings.studentName.tr()} : ${data.studentName}", style: getBoldStyle(fontSize: 16.sp, color: ColorManager.primary)),
                          SizedBox(height: 10.h),
                          Text(data.testName, style: getMediumStyle(fontSize: 15.sp, color: ColorManager.greyTextColor)),
                          SizedBox(height: 8.h),
                          Text("${AppStrings.score.tr()} : ${data.score}", style: getMediumStyle(fontSize: 15.sp, color: ColorManager.greyTextColor)),
                          SizedBox(height: 8.h),
                          Text("${AppStrings.duration.tr()} : ${data.duration}", style: getMediumStyle(fontSize: 15.sp, color: ColorManager.greyTextColor)),
                          SizedBox(height: 8.h),
                          Text("${AppStrings.submittedAt.tr()} : ${data.submittedAt}", style: getMediumStyle(fontSize: 15.sp, color: ColorManager.greyTextColor)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(AppStrings.answers.tr(), style: getBoldStyle(fontSize: 16.sp, color: ColorManager.primary)),
                  SizedBox(height: 8.h),
                  Expanded(
                    child: ListView.separated(
                      itemCount: data.answers.length,
                      separatorBuilder: (_, __) => SizedBox(height: 10.h),
                      itemBuilder: (context, index) {
                        final answer = data.answers[index];
                        return Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: ColorManager.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: answer.isCorrect == 1 ? ColorManager.successGreen : ColorManager.red,
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${AppStrings.question.tr()} : ${answer.question}", style: getBoldStyle(fontSize: 14.sp, color: ColorManager.blackText)),
                              SizedBox(height: 4.h),
                              Text("${AppStrings.selectedAnswer.tr()} : ${answer.selectedAnswer}", style: getMediumStyle(fontSize: 13.sp, color: ColorManager.blackText)),
                              SizedBox(height: 4.h),
                              Text("${AppStrings.correctAnswer.tr()} : ${answer.correctAnswer}", style: getMediumStyle(fontSize: 13.sp, color: ColorManager.blackText)),
                              SizedBox(height: 4.h),
                              Text(answer.isCorrect == 1 ? AppStrings.correct.tr() : AppStrings.incorrect.tr(), style: getBoldStyle(fontSize: 13.sp, color: answer.isCorrect == 1 ? ColorManager.successGreen : ColorManager.red)),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
} 