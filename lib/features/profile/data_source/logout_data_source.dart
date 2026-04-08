import 'dart:developer';

import 'package:elmotamizon/common/base/exports.dart';

abstract class LogoutDataSource {
  Future<Either<Failure, void>> logout({bool isDelete = false});
}

class LogoutDataSourceImpl implements LogoutDataSource {
  final ApiConsumer _apiConsumer;

  LogoutDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, void>> logout({bool isDelete = false}) async {
    try {
      final result = isDelete ? await _apiConsumer.get(Endpoints.deleteAccount) : await _apiConsumer.post(
        Endpoints.logout,
      );
      return result.fold((l) => Left(l), (r) {
        return Right(null);
      });
    } catch (e, stackTrace) {
      log("$stackTrace logout error ${e.toString()}");
      return Left(ServerFailure(message: e.toString()));
    }
  }
} 