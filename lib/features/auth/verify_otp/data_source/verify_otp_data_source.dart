import 'dart:developer';

import 'package:elmotamizon/app/app_prefs.dart';
import 'package:elmotamizon/app/imports.dart';
import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/features/auth/verify_otp/models/verify_otp_model.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

abstract interface class VerifyOtpDataSource {
  Future<Either<Failure, VerifyOtpModel?>> verifyOtp(
      String phone, String otp, bool isForgetPassword);
}

class VerifyOtpDataSourceImpl implements VerifyOtpDataSource {
  final ApiConsumer _apiConsumer;
  VerifyOtpDataSourceImpl(this._apiConsumer);
  @override
  Future<Either<Failure, VerifyOtpModel?>> verifyOtp(
      String phone, String otp, bool isForgetPassword) async {
    try {
      String token = await FirebaseMessaging.instance.getToken() ?? '';
      final response = await _apiConsumer.post(
        isForgetPassword
            ? Endpoints.verifyOTPForgetPassword
            : Endpoints.verifyOTP,
        data: {
          "email": phone,
          "token": otp,
          "fcm_token": token,
        },
      );

      return response.fold((l) => Left(l), (r) async {
        VerifyOtpModel verifyOtpModel = VerifyOtpModel.fromJson(r);
        if (!isForgetPassword) {
          instance<AppPreferences>().saveUserType(verifyOtpModel.data?.user?.userType ?? '');
          instance<AppPreferences>().saveUserName(verifyOtpModel.data?.user?.name ?? '');
          instance<AppPreferences>().saveUserId(verifyOtpModel.data?.user?.id ?? 0);
          instance<AppPreferences>().saveStudentCode(verifyOtpModel.data?.user?.code ?? '');
          instance<AppPreferences>().saveUserImage(verifyOtpModel.data?.user?.image);
          instance<AppPreferences>().saveUserIsAppleReview(
              verifyOtpModel.data?.user?.isAppleReview ?? 0);
          if (verifyOtpModel.data?.token != null) {
            await instance<AppPreferences>()
                .saveToken(verifyOtpModel.data?.token ?? '');
            instance<Dio>().options.headers["Authorization"] =
                "Bearer ${instance<AppPreferences>().getToken()}";
          }
        }
        return Right(isForgetPassword ? null : verifyOtpModel);
      });
    } catch (e, stackTrace) {
      log("$stackTrace verify otp error ${e.toString()}");
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
