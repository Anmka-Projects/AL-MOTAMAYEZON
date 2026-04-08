import 'dart:developer';

import 'package:elmotamizon/common/base/base_model.dart';
import 'package:elmotamizon/common/base/exports.dart';

abstract class DeleteFileDataSource {
  Future<Either<Failure, BaseModel>> deleteFile(int id);
}

class DeleteFileDataSourceImpl implements DeleteFileDataSource {
  final ApiConsumer _apiConsumer;

  DeleteFileDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, BaseModel>> deleteFile(int id) async {
    try {
      final result = await _apiConsumer.delete(Endpoints.deleteFile(id));

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
