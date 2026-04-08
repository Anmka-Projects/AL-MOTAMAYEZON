import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/common/http/endpoints.dart';
import 'package:elmotamizon/common/base/base_model.dart';

abstract class GradeSubmissionDataSource {
  Future<Either<Failure, BaseModel>> gradeSubmission({
    required int submissionId,
    required int grade,
    String? teacherNote,
  });
}

class GradeSubmissionDataSourceImpl implements GradeSubmissionDataSource {
  final ApiConsumer _apiConsumer;
  GradeSubmissionDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, BaseModel>> gradeSubmission({
    required int submissionId,
    required int grade,
    String? teacherNote,
  }) async {
    final result = await _apiConsumer.post(
      Endpoints.gradeSubmission(submissionId),
      data: {
        'grade': grade,
        if (teacherNote != null) 'teacher_note': teacherNote,
      },
    );
    return result.fold(
      (l) => Left(l),
      (r) => Right(BaseModel.fromJson(r)),
    );
  }
} 