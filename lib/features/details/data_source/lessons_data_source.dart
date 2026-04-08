import 'dart:developer';

import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/common/http/params.dart';
import 'package:elmotamizon/features/lesson_details/models/lesson_details_model.dart';

abstract class LessonsDataSource {
  Future<Either<Failure, List<Lesson2Model>>> getLessons(
      PaginationParams params, int courseId);
}

class LessonsDataSourceImpl implements LessonsDataSource {
  final GenericDataSource _genericDataSource;

  LessonsDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, List<Lesson2Model>>> getLessons(
      PaginationParams params, int courseId) async {
    try {
      return await _genericDataSource.fetchData<Lesson2Model>(
        endpoint: Endpoints.lessons(courseId),
        fromJson: Lesson2Model.fromJson,
        params: params,
      );
    } catch (e, stackTrace) {
      log("Lessons error: ${e.runtimeType} - ${e.toString()}",
          stackTrace: stackTrace);
      return Left(ParsingFailure(message: e.toString()));
    }
  }
}
