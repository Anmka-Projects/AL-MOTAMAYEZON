import 'dart:developer';

import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/features/exam_details/models/submission_model.dart';
import 'package:elmotamizon/features/exam_details/models/submit_exam_model.dart';

abstract class SubmitExamDataSource {
  Future<Either<Failure, SubmitExamModel>> submitExam({
    required int examId,
    required int duration,
    required List<SubmissionModel> submissions,
  });
}

class SubmitExamDataSourceImpl implements SubmitExamDataSource {
  final GenericDataSource _genericDataSource;

  SubmitExamDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, SubmitExamModel>> submitExam({
    required int examId,
    required int duration,
    required List<SubmissionModel> submissions,
  }) async {
    try{

      Map<String, dynamic> data = {
        "duration": duration,
      };

      for (int i = 0; i < submissions.length; i++) {
        String key = 'answers[$i][question_id]';
        data[key] = submissions[i].questionId;
        String key2 = 'answers[$i][answer_id]';
        data[key2] = submissions[i].answerId;
      }

      final result = await _genericDataSource.postFormData<Map<String, dynamic>>(
        endpoint: Endpoints.submitExam(examId),
        data: data,
      );
      return result.fold((l) => Left(l), (r){
        return Right(SubmitExamModel.fromJson(r));
      });
    }catch(e,stackTrace){
      log("$stackTrace login error ${e.toString()}");
      return Left(ServerFailure(message: e.toString()));
    }
  }
}