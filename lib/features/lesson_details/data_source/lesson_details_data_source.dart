import 'dart:developer';

import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/features/lesson_details/models/lesson_details_model.dart';

abstract class LessonDetailsDataSource {
  Future<Either<Failure, LessonDetailsModel>> getLessonDetails(String id);
}

class LessonDetailsDataSourceImpl implements LessonDetailsDataSource {
  final ApiConsumer _apiConsumer;

  LessonDetailsDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, LessonDetailsModel>> getLessonDetails(String id) async {
    try{
      final result = await _apiConsumer.get(
        Endpoints.lessonDetails(id),
      );
      return result.fold((l) => Left(l), (r){
        return Right(LessonDetailsModel.fromJson(r));
      });
    }catch(e,stackTrace){
      log("$stackTrace login error ${e.toString()}");
      return Left(ServerFailure(message: e.toString()));
    }
  }
}