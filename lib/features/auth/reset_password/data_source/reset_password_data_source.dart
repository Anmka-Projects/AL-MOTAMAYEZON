import 'dart:developer';

import 'package:elmotamizon/common/base/exports.dart';

abstract interface class ResetPasswordDataSource {
  Future<Either<Failure, String>> resetPassword(
      String phone, String password, String passwordConfirmation);
}

class ResetPasswordDataSourceImpl implements ResetPasswordDataSource {
  final ApiConsumer _apiConsumer;

  ResetPasswordDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, String>> resetPassword(
      String phone, String password, String passwordConfirmation) async {
    try {
      final response = await _apiConsumer.post(
        Endpoints.resetPassword,
        data: {
          "email": phone,
          "password": password,
          "password_confirmation": passwordConfirmation,
        },
      );
      return response.fold((l) => Left(l), (r) {
        return Right(r['message'] ?? "");
      });
    } catch (e, stackTrace) {
      log("$stackTrace reset password error ${e.toString()}");
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
