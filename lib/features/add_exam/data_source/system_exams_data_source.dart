import 'dart:developer';

import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/common/http/params.dart';
import 'package:elmotamizon/features/exam_details/models/exam_details_model.dart';

abstract class SystemExamsDataSource {
  Future<Either<Failure, List<ExamModel>>> getSystemExams(PaginationParams params,int lessonId);
}

class SystemExamsDataSourceImpl implements SystemExamsDataSource {
  final GenericDataSource _genericDataSource;

  SystemExamsDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, List<ExamModel>>> getSystemExams(PaginationParams params,int lessonId) async {
    try {
      return await _genericDataSource.fetchData<ExamModel>(
        endpoint: Endpoints.systemExams(lessonId),
        fromJson: ExamModel.fromJson,
        params: params,
      );
    } catch (e, stackTrace) {
      log("Homeworks error: ${e.runtimeType} - ${e.toString()}", stackTrace: stackTrace);
      return Left(ParsingFailure(message: e.toString()));
    }
  }
}
