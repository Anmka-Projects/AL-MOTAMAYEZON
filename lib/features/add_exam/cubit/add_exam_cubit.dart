import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/features/add_exam/data_source/add_exam_data_source.dart';
import 'package:elmotamizon/features/exam_details/models/exam_details_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_exam_state.dart';

class AddExamCubit extends Cubit<BaseState<String>> {
  final AddExamDataSource _addExamDataSource;
  AddExamCubit(this._addExamDataSource) : super(const BaseState<String>());

  final List<QuestionModel> questions = [];

  Future<void> addExam(
      {
        required String nameAr,
        required String nameEn,
        required int lessonId,
        required String imagePath,
        required String duration,
        int? examId,
        int? resourceExamId,
        String? description,
      }
      ) async
  {
    try {
      emit(state.copyWith(status: Status.loading));

      final result = await _addExamDataSource.addExam(
          nameAr: nameAr,
          nameEn: nameEn,
          lessonId: lessonId,
          imagePath: imagePath,
          duration: duration,
          examId: examId,
          description: description,
          questions: questions,
        resourceExamId: resourceExamId
      );

      result.fold(
            (failure) => emit(
          state.copyWith(
            status: Status.failure,
            errorMessage: failure.message,
            failure: failure,
          ),
        ),
            (message) => emit(
          state.copyWith(
            status: Status.success,
            data: message,
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: Status.failure,
          errorMessage: e.toString(),
          failure: ParsingFailure(message: e.toString()),
        ),
      );
    }
  }


  deleteQuestion(int index){
    emit(DeleteQuestionLoadingState());
    questions.removeAt(index);
    emit(DeleteQuestionSuccessState());
  }

  deleteAnswer(int questionIndex,int answerIndex){
    emit(DeleteQuestionLoadingState());
    questions[questionIndex].answers?.removeAt(answerIndex);
    emit(DeleteQuestionSuccessState());
  }

}
