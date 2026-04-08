import 'dart:developer';
import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/common/http/params.dart';
import 'package:elmotamizon/features/exam_details/models/exam_submission_model.dart';

abstract class ExamSubmissionsDataSource {
  Future<Either<Failure, List<ExamSubmissionModel>>> getExamSubmissions(int examId, PaginationParams params);
}

class ExamSubmissionsDataSourceImpl implements ExamSubmissionsDataSource {
  final GenericDataSource _genericDataSource;
  ExamSubmissionsDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, List<ExamSubmissionModel>>> getExamSubmissions(int examId, PaginationParams params) async {
    try {
      return await _genericDataSource.fetchData<ExamSubmissionModel>(
        endpoint: '/tests/$examId/submissions',
        params: params,
        fromJson: ExamSubmissionModel.fromJson,
      );
    } catch (e, stackTrace) {
      log("exam submissions error: ${e.runtimeType} - ${e.toString()}", stackTrace: stackTrace);
      return Left(ParsingFailure(message: e.toString()));
    }
  }
} 