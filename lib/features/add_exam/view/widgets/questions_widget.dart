import 'package:elmotamizon/app/app_functions.dart';
import 'package:elmotamizon/app/imports.dart';
import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/resources/assets_manager.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/common/resources/styles_manager.dart';
import 'package:elmotamizon/common/widgets/default_button_widget.dart';
import 'package:elmotamizon/common/widgets/default_form_field.dart';
import 'package:elmotamizon/features/add_exam/cubit/add_exam_cubit.dart';
import 'package:elmotamizon/features/add_exam/cubit/delete_question/delete_question_cubit.dart';
import 'package:elmotamizon/features/add_exam/view/widgets/answers_widget.dart';
import 'package:elmotamizon/features/exam_details/models/exam_details_model.dart';
import 'package:elmotamizon/features/lesson_details/cubit/tests_cubit/tests_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elmotamizon/common/widgets/default_pick_files_widget.dart';


class QuestionsWidget extends StatefulWidget {
  final List<QuestionModel>? questions;
  final int? lessonId;
  const QuestionsWidget({super.key, this.questions, this.lessonId,});

  @override
  State<QuestionsWidget> createState() => _QuestionsWidgetState();
}

class _QuestionsWidgetState extends State<QuestionsWidget> {
  late AddExamCubit _addExamCubit;
  
  @override
  void initState() {
    super.initState();
    _addExamCubit = BlocProvider.of<AddExamCubit>(context);
    if(widget.questions == null){
      _addExamCubit.questions.add(QuestionModel(id: 1, title: "", answers: [
        AnswerModel(id: 1, answerText: '',isCorrect: 0),
        AnswerModel(id: 2, answerText: '', isCorrect: 0),
      ],
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => instance<DeleteQuestionCubit>(),
  child: BlocListener<DeleteQuestionCubit, BaseState<String>>(
    listener: (context, state) {
      if (state.status == Status.success) {
        AppFunctions.showsToast(state.data ?? '', ColorManager.successGreen, context);
        instance<TestsCubit>().loadFirstTestsPage(widget.lessonId??0);
      }else if(state.status == Status.failure){
        AppFunctions.showsToast(state.errorMessage ?? '', ColorManager.red, context);
      }
    },
  child: BlocBuilder<AddExamCubit, BaseState<String>>(
  builder: (context, state) {
    return Column(
      children: [
        if(widget.questions != null)
        Column(
          children: List.generate(widget.questions?.length??0, (index) => QuestionWidget(index: index,question: widget.questions![index],isLocal: false,lessonId: widget.lessonId,questions: widget.questions,setState: setState,),),
        ),
        Column(
          children: List.generate(_addExamCubit.questions.length, (index) => QuestionWidget(index: index,question: _addExamCubit.questions[index], isLocal: true,questions: widget.questions,),),
        ),
        Center(
          child: DefaultButtonWidget(
            onPressed: () {
              setState(() {
                _addExamCubit.questions.add(QuestionModel(id: _addExamCubit.questions.length, title: '', answers: [
                  AnswerModel(id: 1, answerText: '', isCorrect: 0),
                  AnswerModel(id: 2, answerText: '', isCorrect: 0),
                ] ) );
              });
            },
            text: AppStrings.addMoreQuestions.tr(),
            horizontalPadding: 10.w,
            isExpanded: false,
            fontSize: 14.sp,
            elevation: 0,
          ),
        ),
      ],
    );
  },
),
),
);
  }
}


class QuestionWidget extends StatefulWidget {
  final int index;
  final QuestionModel question;
  final bool isLocal;
  final int? lessonId;
  final List<QuestionModel>? questions;
  final void Function(void Function())? setState;
   const QuestionWidget({super.key, required this.index, required this.question, required this.isLocal, this.lessonId, this.questions, this.setState});

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  final TextEditingController _titleController = TextEditingController();
  late AddExamCubit _addExamCubit;

  @override
  void initState() {
    super.initState();
    _addExamCubit = BlocProvider.of<AddExamCubit>(context);
    _titleController.text = widget.question.title??'';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: Text("${AppStrings.questionNumber.tr()} ${!widget.isLocal ? widget.index + 1 : ((widget.questions??[]).length) + widget.index + 1}",style: getBoldStyle(fontSize: 13.sp, color: ColorManager.blackText),),
              ),
              BlocBuilder<DeleteQuestionCubit, BaseState<String>>(
              builder: (context, state) {
                return InkWell(
                            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                            onTap: (){
                              if(!widget.isLocal) {
                                context.read<DeleteQuestionCubit>().deleteQuestion(widget.question.id ?? 0);
                                if((widget.questions??[]).isNotEmpty) widget.questions!.removeAt(widget.index);
                                if(widget.setState != null)  widget.setState!(() {});
                              }else{
                                _addExamCubit.deleteQuestion(widget.index);
                              }

                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: Image.asset(IconAssets.delete,width: 25.w,height: 25.w,),
                            ),
                          );
              },
              ),
            ],
          ),
          SizedBox(height: 10.h,),
          DefaultFormField(
              controller: _titleController,
              hintText: AppStrings.title.tr(),
            labelText: AppStrings.title.tr(),
            noBorder: false,
            fillColor: ColorManager.fillColor,
            borderColor: ColorManager.greyBorder,
            enabled: widget.isLocal,
            onChanged: (text) {
              widget.question.title = text;
            },
          ),
          SizedBox(height: 10.h,),
          if (widget.isLocal)
            DefaultPickFilesWidget(
              imagesOnly: true,
              isSingle: true,
              title: 'صورة السؤال',
              onPicked: (filesPaths, filesNames) {
                setState(() {
                  widget.question.image = filesPaths.first;
                });
              },
              clear: (widget.question.image ?? '') == '',
              remoteFiles: (widget.question.image ?? '').isEmpty ? [] : [widget.question.image!],
            ),
          SizedBox(height: 10.h,),
          AnswersWidget(answers: widget.question.answers??[],questionIndex: widget.index,isLocal: widget.isLocal,),
        ],
      ),
    );
  }
}
