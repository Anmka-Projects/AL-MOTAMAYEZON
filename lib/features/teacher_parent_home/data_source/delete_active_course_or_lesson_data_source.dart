import 'dart:developer';

import 'package:elmotamizon/common/base/base_model.dart';
import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/features/details/models/course_or_lesson_or_exam_or_homework_model.dart';

abstract class DeleteActiveCourseOrLessonDataSource {
  Future<Either<Failure, BaseModel>> deleteActiveCourseOrLesson(int id,ItemType type, bool isDelete);
}

class DeleteActiveCourseOrLessonDataSourceImpl implements DeleteActiveCourseOrLessonDataSource {
  final ApiConsumer _apiConsumer;

  DeleteActiveCourseOrLessonDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, BaseModel>> deleteActiveCourseOrLesson(int id,ItemType type, bool isDelete) async {
    try {
      final result =
      type == ItemType.course
          ? (isDelete? await _apiConsumer.delete(Endpoints.deleteCourse(id)):await _apiConsumer.post(Endpoints.toggleActiveCourse(id)))
      : type == ItemType.lesson ? (isDelete? await _apiConsumer.delete(Endpoints.deleteLesson(id)):await _apiConsumer.post(Endpoints.toggleActiveLesson(id)))
      : type == ItemType.homework ? (await _apiConsumer.delete(Endpoints.deleteHomework(id))) : (await _apiConsumer.delete(Endpoints.deleteExam(id)));

      return result.fold(
            (l) => Left(l),
            (r) => Right(BaseModel.fromJson(r)),
      );
    } catch (e, stackTrace) {
      log("DeleteActiveCourseOrLesson error: ${e.runtimeType} - ${e.toString()}", stackTrace: stackTrace);
      return Left(ParsingFailure(message: e.toString()));
    }
  }
}
