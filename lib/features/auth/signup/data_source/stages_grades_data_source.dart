import 'dart:developer';

import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/features/auth/signup/models/stages_grades_model.dart';

abstract class StagesGradesDataSource {
  Future<Either<Failure, StagesGradesModel>> getStagesGrades();
}

class StagesGradesDataSourceImpl implements StagesGradesDataSource {
  final ApiConsumer _apiConsumer;

  StagesGradesDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, StagesGradesModel>> getStagesGrades() async {
    try{
      final result = await _apiConsumer.get(
        Endpoints.stagesGrades,
      );
      return result.fold((l) => Left(l), (r){
        return Right(StagesGradesModel.fromJson(r));
      });
    }catch(e,stackTrace){
      log("$stackTrace login error ${e.toString()}");
      return Left(ServerFailure(message: e.toString()));
    }
  }
}