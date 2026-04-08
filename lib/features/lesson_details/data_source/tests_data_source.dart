import 'dart:developer';

import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/common/http/params.dart';
import 'package:elmotamizon/features/exam_details/models/exam_details_model.dart';

abstract class TestsDataSource {
  Future<Either<Failure, List<ExamModel>>> getExams(PaginationParams params,int lessonId,bool isStudentDetails);
}

class TestsDataSourceSourceImpl implements TestsDataSource {
  final GenericDataSource _genericDataSource;

  TestsDataSourceSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, List<ExamModel>>> getExams(PaginationParams params,int lessonId,bool isStudentDetails) async {
    try {
      return await _genericDataSource.fetchData<ExamModel>(
        endpoint:  Endpoints.exams(lessonId,isStudentDetails: isStudentDetails),
        fromJson: ExamModel.fromJson,
        params: params,
      );
    } catch (e, stackTrace) {
      log("Homeworks error: ${e.runtimeType} - ${e.toString()}", stackTrace: stackTrace);
      return Left(ParsingFailure(message: e.toString()));
    }
  }
}
