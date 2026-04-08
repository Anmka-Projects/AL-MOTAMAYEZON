import 'dart:developer';

import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/common/http/params.dart';
import 'package:elmotamizon/features/home/details/models/lessons_content_model.dart';

abstract class LessonsContentDataSource {
  Future<Either<Failure, List<LessonModel>>> getLessonsContent(
      PaginationParams params, int courseId);
}

class LessonsContentDataSourceImpl implements LessonsContentDataSource {
  final GenericDataSource _genericDataSource;

  LessonsContentDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, List<LessonModel>>> getLessonsContent(
      PaginationParams params, int courseId) async {
    try {
      return await _genericDataSource.fetchData<LessonModel>(
        endpoint: Endpoints.lessonsContent(courseId),
        fromJson: LessonModel.fromJson,
        params: params,
      );
    } catch (e, stackTrace) {
      log("LessonsContent error: ${e.runtimeType} - ${e.toString()}",
          stackTrace: stackTrace);
      return Left(ParsingFailure(message: e.toString()));
    }
  }
}
