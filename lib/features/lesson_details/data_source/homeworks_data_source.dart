import 'dart:developer';

import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/common/http/params.dart';
import 'package:elmotamizon/features/lesson_details/models/homeworks_model.dart';

abstract class HomeworksDataSource {
  Future<Either<Failure, List<HomeworkModel>>> getHomeworks(PaginationParams params,int lessonId,bool isStudentDetails);
}

class HomeworksDataSourceImpl implements HomeworksDataSource {
  final GenericDataSource _genericDataSource;

  HomeworksDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, List<HomeworkModel>>> getHomeworks(PaginationParams params,int lessonId,bool isStudentDetails) async {
    try {
      return await _genericDataSource.fetchData<HomeworkModel>(
        endpoint: Endpoints.homeworks(lessonId,isStudentDetails: isStudentDetails),
        fromJson: HomeworkModel.fromJson,
        params: params,
      );
    } catch (e, stackTrace) {
      log("Homeworks error: ${e.runtimeType} - ${e.toString()}", stackTrace: stackTrace);
      return Left(ParsingFailure(message: e.toString()));
    }
  }
}
