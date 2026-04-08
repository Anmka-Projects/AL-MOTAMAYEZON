import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/styles_manager.dart';
import 'package:elmotamizon/common/widgets/custom_pull_to_request.dart';
import 'package:elmotamizon/common/widgets/default_app_bar.dart';
import 'package:elmotamizon/common/widgets/default_error_widget.dart';
import 'package:elmotamizon/features/exam_details/cubit/exam_submissions_cubit.dart';
import 'package:elmotamizon/features/exam_details/models/exam_submission_model.dart';
import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/features/exam_details/view/exam_submission_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elmotamizon/app/imports.dart';
import 'package:elmotamizon/app/app_functions.dart';

class ExamSubmissionsView extends StatelessWidget {
  final int examId;
  const ExamSubmissionsView({super.key, required this.examId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => instance<ExamSubmissionsCubit>()..loadFirstExamSubmissionsPage(examId: examId),
      child: Scaffold(
        appBar: DefaultAppBar(text: AppStrings.submissions.tr(),backgroundColor: ColorManager.primary,titleColor: ColorManager.white,),
        backgroundColor: ColorManager.bg,
        body: BlocBuilder<ExamSubmissionsCubit, BaseState<ExamSubmissionModel>>(
          builder: (context, state) {
            if (state.status == Status.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == Status.failure) {
              return DefaultErrorWidget(errorMessage: state.errorMessage ?? '');
            }
            final submissions = state.items;
            if (submissions.isEmpty) {
              return DefaultErrorWidget(errorMessage: state.errorMessage ?? '');
            }
            return PullToRefresh(
              enableLoadMore: true,
              enableRefresh: false,
              onLoadMore: () => context.read<ExamSubmissionsCubit>().loadMoreExamSubmissionsPage(examId: examId),
              builder: (context) {
                return ListView.separated(
                  padding: EdgeInsets.all(16.w),
                  itemCount: submissions.length,
                  separatorBuilder: (_, __) => SizedBox(height: 10.h),
                  itemBuilder: (context, index) {
                    final submission = submissions[index];
                    return Material(
                      elevation: 3,
                      borderRadius: BorderRadius.circular(12.r),
                      child: ListTile(
                        tileColor: ColorManager.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                        title: Text(submission.studentName, style: getBoldStyle(fontSize: 15.sp, color: ColorManager.primary)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5.h,),
                            Text("${AppStrings.score.tr()} : ${submission.score}", style: getMediumStyle(fontSize: 14.sp, color: ColorManager.greyTextColor)),
                            SizedBox(height: 5.h,),
                            Text("${AppStrings.duration.tr()} : ${submission.duration}", style: getMediumStyle(fontSize: 14.sp, color: ColorManager.greyTextColor)),
                            SizedBox(height: 5.h,),
                            Text("${AppStrings.submittedAt.tr()} : ${submission.submittedAt}", style: getMediumStyle(fontSize: 14.sp, color: ColorManager.greyTextColor)),
                          ],
                        ),
                        onTap: () {
                          AppFunctions.navigateTo(
                            context,
                            ExamSubmissionDetailsView(
                              examId: examId,
                              submissionId: submission.id,
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              }
            );
          },
        ),
      ),
    );
  }
} 