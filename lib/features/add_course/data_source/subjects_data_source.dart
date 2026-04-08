import 'dart:developer';

import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/features/add_course/models/subjects_model.dart';
import 'package:easy_localization/easy_localization.dart';

abstract class SubjectsDataSource {
  Future<Either<Failure, SubjectsModel>> getSubjects();
}

class SubjectsDataSourceImpl implements SubjectsDataSource {
  final ApiConsumer _apiConsumer;

  SubjectsDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, SubjectsModel>> getSubjects() async {
    try{
      final result = await _apiConsumer.get(
        Endpoints.subjects,
      );
      return result.fold((l) => Left(l), (r){
        return Right(SubjectsModel.fromJson(r));
      });
    }catch(e,stackTrace){
      log("$stackTrace login error ${e.toString()}");
      return Left(ServerFailure(message: AppStrings.unKnownError.tr()));
    }
  }
}