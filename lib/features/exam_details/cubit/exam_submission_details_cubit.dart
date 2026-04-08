import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/features/exam_details/models/exam_submission_details_model.dart';
import 'package:elmotamizon/features/exam_details/data_source/exam_submission_details_data_source.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExamSubmissionDetailsCubit extends Cubit<BaseState<ExamSubmissionDetailsModel>> {
  final ExamSubmissionDetailsDataSource dataSource;
  ExamSubmissionDetailsCubit(this.dataSource) : super(const BaseState());

  Future<void> getExamSubmissionDetails({required int submissionId}) async {
    emit(state.copyWith(status: Status.loading));
    final result = await dataSource.getExamSubmissionDetails(submissionId: submissionId);
    result.fold(
      (failure) => emit(state.copyWith(status: Status.failure, errorMessage: failure.message)),
      (data) => emit(state.copyWith(status: Status.success, data: data)),
    );
  }
} 