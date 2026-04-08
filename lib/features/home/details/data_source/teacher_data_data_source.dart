import 'dart:developer';

import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/features/home/details/models/teacher_model.dart';

abstract class TeacherDataSource {
  Future<Either<Failure, TeacherDetailsModel>> getTeacher();
}

class TeacherDataSourceImpl implements TeacherDataSource {
  final ApiConsumer _apiConsumer;

  TeacherDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, TeacherDetailsModel>> getTeacher() async {
    try {
      final result = await _apiConsumer.get(
        Endpoints.teacher,
      );
      return result.fold((l) => Left(l), (r) {
        return Right(TeacherDetailsModel.fromJson(r));
      });
    } catch (e, stackTrace) {
      log("$stackTrace login error ${e.toString()}");
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
