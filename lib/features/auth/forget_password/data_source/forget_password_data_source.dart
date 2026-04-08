import 'dart:developer';

import 'package:elmotamizon/common/base/exports.dart';

abstract class ForgetPasswordDataSource {
  Future<Either<Failure, void>> forgetPassword(String phone);
}

class ForgetPasswordDataSourceImpl implements ForgetPasswordDataSource {
  final ApiConsumer _apiConsumer;

  ForgetPasswordDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, void>> forgetPassword(String phone) async {
    try {
      final result = await _apiConsumer.post(
        Endpoints.forgetPassword,
        data: {
          "email": phone,
        },
      );
      return result.fold(
        (l) => Left(l),
        (r) => Right(null),
      );
    } catch (e, stackTrace) {
      log("$stackTrace login error ${e.toString()}");
      return Left(ParsingFailure(message: e.toString()));
    }
  }
}
