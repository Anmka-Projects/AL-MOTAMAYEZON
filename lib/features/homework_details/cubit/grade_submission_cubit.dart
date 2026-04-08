import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/features/homework_details/data_source/grade_submission_data_source.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'grade_submission_state.dart';

class GradeSubmissionCubit extends Cubit<GradeSubmissionState> {
  GradeSubmissionCubit(this._gradeSubmissionDataSource) : super(const GradeSubmissionState());
  final GradeSubmissionDataSource _gradeSubmissionDataSource;

  Future<void> gradeSubmission({
    required int submissionId,
    required int grade,
    String? teacherNote,
  }) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _gradeSubmissionDataSource.gradeSubmission(
      submissionId: submissionId,
      grade: grade,
      teacherNote: teacherNote,
    );
    result.fold(
      (failure) => emit(state.copyWith(status: Status.failure, errorMessage: failure.message, failure: failure)),
      (baseModel) => emit(state.copyWith(status: Status.success, message: baseModel.message)),
    );
  }
} 