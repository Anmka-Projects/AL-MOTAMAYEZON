import 'dart:developer';
import 'package:elmotamizon/common/base/exports.dart';

abstract class ViewVideoDataSource {
  Future<Either<Failure, void>> viewVideo(int id);
}

class ViewVideoDataSourceImpl implements ViewVideoDataSource {
  final ApiConsumer _apiConsumer;

  ViewVideoDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, void>> viewVideo(int id) async {
    try {
      final result = await _apiConsumer.post(
        Endpoints.viewVideo(id),
        data: {},
      );
      return result.fold((l) => Left(l), (r) {
        return Right(null);
      });
    } catch (e, stackTrace) {
      log("$stackTrace login error ${e.toString()}");
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
