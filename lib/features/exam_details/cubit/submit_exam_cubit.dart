import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/features/exam_details/data_source/submit_exam_data_source.dart';
import 'package:elmotamizon/features/exam_details/models/submission_model.dart';
import 'package:elmotamizon/features/exam_details/models/submit_exam_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class SubmitExamCubit extends Cubit<BaseState<SubmitExamModel>> {
  SubmitExamCubit(this._courseDetailsDataSource) : super(const BaseState<SubmitExamModel>());
  final SubmitExamDataSource _courseDetailsDataSource;

  List<SubmissionModel> submissions = [];
  int duration = 0;

  Future<void> submitExam({
    required int examId,
  }) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _courseDetailsDataSource.submitExam(
       examId: examId,
       duration: duration,
       submissions: submissions,
    );
    result.fold(
          (failure) => emit(state.copyWith(status: Status.failure, failure: failure, errorMessage: failure.message)),
          (success) => emit(state.copyWith(status: Status.success, data: success)),
    );
  }
}
