import 'dart:developer';

import 'package:elmotamizon/common/base/base_model.dart';
import 'package:elmotamizon/common/base/exports.dart';

abstract class DeleteQuestionDataSource {
  Future<Either<Failure, BaseModel>> deleteQuestion(int id);
}

class DeleteQuestionDataSourceImpl implements DeleteQuestionDataSource {
  final ApiConsumer _apiConsumer;

  DeleteQuestionDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, BaseModel>> deleteQuestion(int id) async {
    try {
      final result = await _apiConsumer.delete(Endpoints.deleteQuestion(id));

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
