import 'dart:developer';

import 'package:elmotamizon/common/base/base_model.dart';
import 'package:elmotamizon/common/base/exports.dart';

abstract class AssignStudentDataSource {
  Future<Either<Failure, BaseModel>> assignStudent(String code);
}

class AssignStudentDataSourceImpl implements AssignStudentDataSource {
  final ApiConsumer _apiConsumer;

  AssignStudentDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, BaseModel>> assignStudent(String code) async {
    try {
      final result = await _apiConsumer.post(
        Endpoints.assignStudent,
        data: {
          "code": code,
        },
      );
      return result.fold(
            (l) => Left(l),
            (r) => Right(BaseModel.fromJson(r)),
      );
    } catch (e, stackTrace) {
      log("AssignStudent error: ${e.runtimeType} - ${e.toString()}", stackTrace: stackTrace);
      return Left(ParsingFailure(message: e.toString()));
    }
  }
}
