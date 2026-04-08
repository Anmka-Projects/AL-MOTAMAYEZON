import 'dart:developer';

import 'package:elmotamizon/app/app_prefs.dart';
import 'package:elmotamizon/app/imports.dart';
import 'package:elmotamizon/common/base/exports.dart';

abstract class SubscribeTeacherDataSource {
  Future<Either<Failure, String>> subscribeTeacher({
    required int teacherId,
    bool isBook = false,
  });
}

class SubscribeTeacherDataSourceImpl implements SubscribeTeacherDataSource {
  final ApiConsumer _apiConsumer;

  SubscribeTeacherDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, String>> subscribeTeacher({
    required int teacherId,
    bool isBook = false,
  }) async {
    try{
      final result = await _apiConsumer.post(
          instance<AppPreferences>().getUserIsAppleReview() == 1 && !isBook ? Endpoints.subscribeAppleReviewTeacher(teacherId) : Endpoints.subscribeTeacher,
        data: isBook ? {
            "book_id": teacherId
          } : {
          "course_id": teacherId,
        }
      );
      return result.fold((l) => Left(l), (r){
        return Right(r['payment_url']??'');
      });
    }catch(e,stackTrace){
      log("$stackTrace login error ${e.toString()}");
      return Left(ServerFailure(message: e.toString()));
    }
  }
}