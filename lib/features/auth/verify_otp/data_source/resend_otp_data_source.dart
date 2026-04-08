import 'dart:developer';
import 'package:elmotamizon/common/base/exports.dart';

abstract interface class ResendOtpDataSource {
  Future<Either<Failure, String>> resendOtp(
      String phone, bool isForgetPassword);
}

class ResendOtpDataSourceImpl implements ResendOtpDataSource {
  final ApiConsumer _apiConsumer;
  ResendOtpDataSourceImpl(this._apiConsumer);
  @override
  Future<Either<Failure, String>> resendOtp(
      String phone, bool isForgetPassword) async {
    try {
      final response = await _apiConsumer.post(
        isForgetPassword
            ? Endpoints.resendOTPForgetPassword
            : Endpoints.resendOTP,
        data: {
          "email": phone,
        },
      );
      return response.fold((l) => Left(l), (r) {
        return Right(r['message'] ?? "");
      });
    } catch (e, stackTrace) {
      log("$stackTrace resend otp error ${e.toString()}");
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
