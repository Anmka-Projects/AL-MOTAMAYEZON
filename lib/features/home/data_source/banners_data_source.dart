import 'dart:developer';

import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/features/home/model/banners_model.dart';

abstract class BannersDataSource {
  Future<Either<Failure, BannersModel>> getBanners();
}

class BannersDataSourceImpl implements BannersDataSource {
  final ApiConsumer _apiConsumer;

  BannersDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, BannersModel>> getBanners() async {
    try{
      final result = await _apiConsumer.get(
        Endpoints.banners,
      );
      return result.fold((l) => Left(l), (r){
        return Right(BannersModel.fromJson(r));
      });
    }catch(e,stackTrace){
      log("$stackTrace login error ${e.toString()}");
      return Left(ServerFailure(message: e.toString()));
    }
  }
}