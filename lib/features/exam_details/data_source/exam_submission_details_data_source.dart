import 'dart:developer';
import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/features/exam_details/models/exam_submission_details_model.dart';

abstract class ExamSubmissionDetailsDataSource {
  Future<Either<Failure, ExamSubmissionDetailsModel>> getExamSubmissionDetails({required int submissionId});
}

class ExamSubmissionDetailsDataSourceImpl implements ExamSubmissionDetailsDataSource {
  final GenericDataSource _genericDataSource;
  ExamSubmissionDetailsDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, ExamSubmissionDetailsModel>> getExamSubmissionDetails({required int submissionId}) async {
    try {
      return await _genericDataSource.fetchResult<ExamSubmissionDetailsModel>(
        endpoint: Endpoints.submissionDetails(submissionId)
            // '/tests/$examId/submissions/$submissionId'
        ,
        fromJson: ExamSubmissionDetailsModel.fromJson,
      );
    } catch (e, stackTrace) {
      log("exam submission details error: ${e.runtimeType} - ${e.toString()}", stackTrace: stackTrace);
      return Left(ParsingFailure(message: e.toString()));
    }
  }
} 