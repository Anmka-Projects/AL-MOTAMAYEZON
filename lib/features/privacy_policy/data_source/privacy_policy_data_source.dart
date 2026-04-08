import 'dart:developer';

import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/features/privacy_policy/models/privacy_policy_model.dart';
import 'package:elmotamizon/features/privacy_policy/view/privacy_policy_view.dart';

abstract class PrivacyPolicyDataSource {
  Future<Either<Failure, PrivacyPolicyModel>> getPrivacyPolicy({
   required InfoType type,
  });
}

class PrivacyPolicyDataSourceImpl implements PrivacyPolicyDataSource {
  final ApiConsumer _apiConsumer;

  PrivacyPolicyDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, PrivacyPolicyModel>> getPrivacyPolicy({
    required InfoType type,
  }) async {
    try{
      final result = await _apiConsumer.get(
       type == InfoType.aboutUs ? Endpoints.about : type == InfoType.privacyPolicy ? Endpoints.privacyPolicy : Endpoints.terms,
      );
      return result.fold((l) => Left(l), (r){
        return Right(PrivacyPolicyModel.fromJson(r));
      });
    }catch(e,stackTrace){
      log("$stackTrace login error ${e.toString()}");
      return Left(ServerFailure(message: e.toString()));
    }
  }
}