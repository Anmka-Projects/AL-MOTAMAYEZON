import 'dart:developer';

import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/features/exam_details/models/exam_details_model.dart';

abstract class ExamDetailsDataSource {
  Future<Either<Failure, ExamDetailsModel>> getExamDetails(int id);
}

class ExamDetailsDataSourceImpl implements ExamDetailsDataSource {
  final ApiConsumer _apiConsumer;

  ExamDetailsDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, ExamDetailsModel>> getExamDetails(int id) async {
    try{
      final result = await _apiConsumer.get(
        Endpoints.examDetails(id),
      );
      return result.fold((l) => Left(l), (r){
        return Right(ExamDetailsModel.fromJson(r));
      });
    }catch(e,stackTrace){
      log("$stackTrace login error ${e.toString()}");
      return Left(ServerFailure(message: e.toString()));
    }
  }
}