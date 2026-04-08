import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/features/add_exam/data_source/delete_question_data_source.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteQuestionCubit extends Cubit<BaseState<String>> {
  DeleteQuestionCubit(this._deleteQuestionDataSource)
      : super(const BaseState<String>());

  final DeleteQuestionDataSource _deleteQuestionDataSource;

  Future<void> deleteQuestion(int id) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _deleteQuestionDataSource.deleteQuestion(id);
    result.fold(
          (l) => emit(state.copyWith(
          failure: l, status: Status.failure, errorMessage: l.message)),
          (r) => emit(state.copyWith(status: Status.success,data: r.message)),
    );
  }
}
