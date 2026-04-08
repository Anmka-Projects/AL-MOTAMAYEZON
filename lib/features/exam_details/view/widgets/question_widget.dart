import 'package:elmotamizon/app/app_prefs.dart';
import 'package:elmotamizon/app/imports.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/common/resources/styles_manager.dart';
import 'package:elmotamizon/common/widgets/default_button_widget.dart';
import 'package:elmotamizon/common/widgets/default_image_widget.dart';
import 'package:elmotamizon/features/exam_details/cubit/submit_exam_cubit.dart';
import 'package:elmotamizon/features/exam_details/models/exam_details_model.dart';
import 'package:elmotamizon/features/exam_details/models/submission_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuestionWidget extends StatefulWidget {
  final QuestionModel question;
  final int index;
  const QuestionWidget({super.key, required this.question, required this.index});

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  int? _selectedId = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("${AppStrings.question.tr()} ${widget.index+1}",style: getBoldStyle(fontSize: 15.sp, color: ColorManager.lightGreyTextColor),),
        SizedBox(height: 5.h,),
        Text(widget.question.title??'',style: getBoldStyle(fontSize: 15.sp, color: ColorManager.greyTextColor),),
        SizedBox(height: 15.h,),
        if((widget.question.image??'').isNotEmpty)
        DefaultImageWidget(image: widget.question.image??''),
        SizedBox(height: 15.h,),
        Column(children: List.generate((widget.question.answers??[]).length, (index) => _option((widget.question.answers??[])[index],widget.question.id??0),),),
        SizedBox(height: 10.h,),
        const Divider(color: ColorManager.greyBorder,),
        SizedBox(height: 10.h,),
      ],
    );
  }

  _option(AnswerModel answer,int questionId) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: DefaultButtonWidget(
        onPressed: () {
          setState(() {
            _selectedId = answer.id;
            if(instance<SubmitExamCubit>().submissions.any((element) => element.questionId == questionId)) {
              instance<SubmitExamCubit>().submissions.removeWhere((element) => element.questionId == questionId,);
            }
            instance<SubmitExamCubit>().submissions.add(SubmissionModel(questionId: questionId, answerId: answer.id??0));
          });
        },
        overlayColor: ColorManager.primary.withOpacity(.1),
        color: ColorManager.white,
        verticalPadding: 0,
        horizontalPadding: 0,
        radius: 0,
        elevation: 2,
        child: IntrinsicHeight(
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                margin: EdgeInsetsDirectional.only(end: 10.w),
                color: (instance<AppPreferences>().getUserType() == 'teacher' ? (answer.isCorrect == 1) : (_selectedId == answer.id)) ? ColorManager.primary : ColorManager.white,
                width: 10.w,
                // height: 30.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Text(answer.answerText??'',style: getBoldStyle(fontSize: 15.sp, color: ColorManager.greyTextColor),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
