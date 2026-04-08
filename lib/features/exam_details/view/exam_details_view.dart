import 'package:elmotamizon/app/app_functions.dart';
import 'package:elmotamizon/app/app_prefs.dart';
import 'package:elmotamizon/app/imports.dart';
import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/resources/assets_manager.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/language_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/common/resources/styles_manager.dart';
import 'package:elmotamizon/common/widgets/default_button_widget.dart';
import 'package:elmotamizon/common/widgets/default_error_widget.dart';
import 'package:elmotamizon/common/widgets/down_count_timer.dart';
import 'package:elmotamizon/features/details/view/widgets/header_image_widget.dart';
import 'package:elmotamizon/features/exam_details/cubit/exam_details_cubit.dart';
import 'package:elmotamizon/features/exam_details/cubit/submit_exam_cubit.dart';
import 'package:elmotamizon/features/exam_details/models/exam_details_model.dart';
import 'package:elmotamizon/features/exam_details/models/submit_exam_model.dart';
import 'package:elmotamizon/features/exam_details/view/exam_submissions_view.dart';
import 'package:elmotamizon/features/exam_details/view/widgets/question_widget.dart';
import 'package:elmotamizon/features/lesson_details/cubit/tests_cubit/tests_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ExamDetailsView extends StatefulWidget {
  final int examId;
  final int lessonId;
  final BuildContext examsContext;
  const ExamDetailsView({super.key, required this.examId, required this.lessonId, required this.examsContext});

  @override
  State<ExamDetailsView> createState() => _ExamDetailsViewState();
}

class _ExamDetailsViewState extends State<ExamDetailsView> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      instance<SubmitExamCubit>().submissions.clear();
    },);
  }

  void showExamResultDialog(BuildContext context, SubmitExamModel? model) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Center(
            child: Text(
              AppStrings.examResult.tr(),
              style: getBoldStyle(fontSize: 18.sp, color: ColorManager.primary),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10.h),
              _resultRow(AppStrings.score.tr(), model?.data?.score?.toString() ?? '-'),
              SizedBox(height: 8.h),
              _resultRow(AppStrings.totalQuestions.tr(), model?.data?.totalQuestions?.toString() ?? '-'),
              SizedBox(height: 8.h),
              _resultRow(AppStrings.percentage.tr(), "${model?.data?.percentage?.toString() ?? '-'}%"),
              SizedBox(height: 20.h),
              DefaultButtonWidget(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  // Navigator.of(this.context).pop(); // Close exam page
                },
                text: AppStrings.ok.tr(),
                color: ColorManager.primary,
                textColor: ColorManager.white,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _resultRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: getSemiBoldStyle(fontSize: 15.sp, color: ColorManager.blackText)),
        Text(value, style: getBoldStyle(fontSize: 15.sp, color: ColorManager.primary)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
  providers: [
    BlocProvider(
  create: (context) => instance<ExamDetailsCubit>()..getExamDetails(widget.examId),
),
    BlocProvider.value(
      value: instance<SubmitExamCubit>(),
    ),
  ],
  child: PopScope(
    canPop: instance<AppPreferences>().getUserType() != "student" ? true : false,
    child: Scaffold(
        backgroundColor: ColorManager.bg,
        body: BlocBuilder<ExamDetailsCubit, BaseState<ExamDetailsModel>>(
    builder: (context, state) {
      if (state.status == Status.failure) {
        return DefaultErrorWidget(
          errorMessage: state.errorMessage ?? '',
          buttonTitle: AppStrings.back.tr(),
          onPressed: () => Navigator.of(context).pop(),);
      }
      if (state.status == Status.loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderImageWidget(
              name: state.data?.data?.name ?? '',
              image: state.data?.data?.image ?? '',
              onClose: instance<AppPreferences>().getUserType() != "student" ? null : () {
                  instance<SubmitExamCubit>().submitExam(examId: state.data?.data?.id??0);
              },
            ),
            _time(state.data?.data),
            Divider(height: 10.h,color: ColorManager.greyBorder,),
            if(instance<AppPreferences>().getUserType() == "teacher")
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 10.h),
              child: DefaultButtonWidget(
                text: AppStrings.studentSubmissions.tr(),
                textColor: ColorManager.white,
                color: ColorManager.primary,
                onPressed: () {
                  AppFunctions.navigateTo(context, ExamSubmissionsView(examId: widget.examId));
                },
              ),
            ),
            if((state.data?.data?.description??'').isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Text(
                state.data?.data?.description ?? '',
                style:
                getBoldStyle(fontSize: 15.sp, color: ColorManager.blackText),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(bottom: 20.h,left: 15.w,right: 15.w),
                children: [
                  SizedBox(height: 10.h,),
                  _body(state.data?.data),
                  if(instance<AppPreferences>().getUserType() == "student")
                  BlocConsumer<SubmitExamCubit, BaseState<SubmitExamModel>>(
    listener: (context, state) {
     if(state.status == Status.success){
       widget.examsContext.read<TestsCubit>().loadFirstTestsPage(widget.lessonId);
       showExamResultDialog(context, state.data);
     }else if(state.status == Status.failure){
       AppFunctions.showsToast(state.errorMessage??'', ColorManager.red, context);
     }
    },
    builder: (context, submitExamState) {
      return DefaultButtonWidget(
                    onPressed: () {
                      instance<SubmitExamCubit>().submitExam(examId: state.data?.data?.id??0);
                    },
                    text: AppStrings.submit.tr(),
                    textColor: ColorManager.white,
                    color: ColorManager.primary,
        isLoading: submitExamState.status == Status.loading,
                  );
    },
    ),
                ],
              ),
            ),
          ],
        );
    },
    ),
      ),
  ),
);
  }

  _time(ExamModel? exam){
    return Padding(
      padding: EdgeInsets.fromLTRB(15.w, 15.h, 15.w, 5.h),
      child: Row(
        children: [
          Expanded(child: Text(language == "ar" ? "اسئلة: ${exam?.questions?.length ?? 0} س" : "Questions: ${exam?.questions?.length ?? 0} Q",style: getSemiBoldStyle(fontSize: 15.sp, color: ColorManager.blackText),)),
          SizedBox(width: 10.w,),
          if(instance<AppPreferences>().getUserType() == "student")
          CountdownPage(startMinutes: exam?.duration??0,id: exam?.id,),
          SizedBox(width: 10.w,),
          SvgPicture.asset(IconAssets.clock,height: 5.w,width: 5.w),
          SizedBox(width: 10.w,),
          Text("${exam?.duration??0} ${AppStrings.minutes.tr()}",style: getRegularStyle(fontSize: 13.sp, color: ColorManager.blackText),),
        ],
      ),
    );
  }

  _body(ExamModel? exam){
    return Column(
      children: List.generate(exam?.questions?.length??0, (index) => QuestionWidget(question: (exam?.questions??[])[index],index: index,),),
    );
  }

}
