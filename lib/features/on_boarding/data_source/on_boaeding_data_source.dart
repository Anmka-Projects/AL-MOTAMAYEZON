import 'dart:developer';

import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/features/on_boarding/model/on_boarding_model.dart';

abstract class OnBoardingDataSource {
  Future<Either<Failure, OnBoardingModel>> getOnBoarding();
}

class OnBoardingDataSourceImpl implements OnBoardingDataSource {
  final ApiConsumer _apiConsumer;

  OnBoardingDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, OnBoardingModel>> getOnBoarding() async {
    try{
      final result = await _apiConsumer.get(
        Endpoints.onBoarding,
      );
      return result.fold((l) => Left(l), (r){
        return Right(OnBoardingModel.fromJson(r));
      });
    }catch(e,stackTrace){
      log("$stackTrace login error ${e.toString()}");
      return Left(ServerFailure(message: e.toString()));
    }
  }
}