import 'package:elmotamizon/app/app_functions.dart';
import 'package:elmotamizon/common/resources/assets_manager.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/common/widgets/default_button_widget.dart';
import 'package:elmotamizon/common/widgets/default_form_field.dart';
import 'package:elmotamizon/features/add_exam/cubit/add_exam_cubit.dart';
import 'package:elmotamizon/features/exam_details/models/exam_details_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnswersWidget extends StatefulWidget {
  final int questionIndex;
  final List<AnswerModel> answers;
  final bool isLocal;
   const AnswersWidget({super.key, required this.answers, required this.questionIndex, this.isLocal = false});

  @override
  State<AnswersWidget> createState() => _AnswersWidgetState();
}

class _AnswersWidgetState extends State<AnswersWidget> {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          children: List.generate(widget.answers.length, (index) => AnswerWidget(
            answer: widget.answers[index],
            index: index,
            questionIndex: widget.questionIndex,
            isLocal: widget.isLocal,
            answers: widget.answers,
            setState: setState,
          ),),
        ),
        if(widget.isLocal)
        DefaultButtonWidget(
          onPressed: () {
          setState(() {
            widget.answers.add(
                AnswerModel(
                    id: widget.answers.length + 1,
                    answerText: '',
                    isCorrect: 0,
                ));
          });
        },
          text: AppStrings.addMoreAnswers.tr(),
          horizontalPadding: 10.w,
          isExpanded: false,
          fontSize: 12.sp,
          elevation: 0,
        ),
      ],
    );
  }
}

class AnswerWidget extends StatefulWidget {
  final int index;
  final int questionIndex;
  final AnswerModel answer;
  final bool isLocal;
  final List<AnswerModel> answers;
  final void Function(void Function()) setState;

  const AnswerWidget({super.key, required this.answer, required this.index, required this.questionIndex, this.isLocal = false, required this.answers, required this.setState});

  @override
  State<AnswerWidget> createState() => _AnswerWidgetState();
}

class _AnswerWidgetState extends State<AnswerWidget> {
  final TextEditingController _answerController = TextEditingController();
  late AddExamCubit _addExamCubit;

  @override
  void initState() {
    super.initState();
    _addExamCubit = BlocProvider.of<AddExamCubit>(context);
    _answerController.text = widget.answer.answerText??'';
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: DefaultFormField(
          controller: _answerController,
          hintText: "${AppStrings.answer.tr()} ${widget.index + 1}",
          labelText: "${AppStrings.answer.tr()} ${widget.index + 1}",
        noBorder: false,
        fillColor: ColorManager.fillColor,
        borderColor: ColorManager.greyBorder,
        enabled: widget.isLocal,
        onChanged: (text) {
          widget.answer.answerText = text;
        },
        prefixWidget: Checkbox(value: widget.answer.isCorrect == 1, onChanged: (value) {
          widget.answer.isCorrect = 1;
          for (AnswerModel element in widget.answers) {
            if(element.id != widget.answer.id) element.isCorrect = 0;
          }
           widget.setState((){});
        },),
        suffixIcon: !widget.isLocal ? null : InkWell(
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          onTap: (){
            if((_addExamCubit.questions[widget.questionIndex].answers?.length??0) <= 2){
              AppFunctions.showsToast(AppStrings.cantDelete.tr(),ColorManager.red,context);
              return;
            }
            _addExamCubit.deleteAnswer(widget.questionIndex,widget.index);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Image.asset(IconAssets.delete,width: 15.w,height: 15.w,),
          ),
        ),
      ),
    );
  }
}

