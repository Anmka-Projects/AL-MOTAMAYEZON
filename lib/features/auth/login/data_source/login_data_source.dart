import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:elmotamizon/app/app_prefs.dart';
import 'package:elmotamizon/app/imports.dart';
import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

abstract class LoginDataSource {
  Future<Either<Failure, void>> login(String email, String password);
}

class LoginDataSourceImpl implements LoginDataSource {
  final ApiConsumer _apiConsumer;

  LoginDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, void>> login(String email, String password) async {
    try {
      String serialNumber = 'device not have id';
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        serialNumber = androidInfo.id;
      } else if (Platform.isIOS || Platform.isMacOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        serialNumber = iosInfo.identifierForVendor??'device not have id';
      }
      String fcmToken = await FirebaseMessaging.instance.getToken() ?? "";
      final result = await _apiConsumer.post(
        Endpoints.login,
        data: {
          "email": email,
          "password": password,
          "fcm_token": fcmToken,
          "device_id": serialNumber,
        },
      );
      return result.fold((l) => Left(l), (r) async {
        await Future.wait([
          instance<AppPreferences>()
              .saveUserType(r['data']["user"]["user_type"]??'student'),
          instance<AppPreferences>().saveUserName(r['data']["user"]["name"]??''),
          instance<AppPreferences>().saveUserId(r['data']["user"]["id"]??0),
          instance<AppPreferences>().saveStudentCode(r['data']["user"]["code"]??''),
          instance<AppPreferences>().saveUserImage(r['data']["user"]["image"]??''),
          instance<AppPreferences>().saveToken(r['data']["token"]??''),
          instance<AppPreferences>().saveUserIsAppleReview(
              r['data']["user"]?["is_apple_review"] ?? 0),
        ]);
        instance<Dio>().options.headers["Authorization"] =
            "Bearer ${instance<AppPreferences>().getToken()}";
        return Right(null);
      });
    } catch (e, stackTrace) {
      log("$stackTrace login error ${e.toString()}");
      return Left(ServerFailure(message: AppStrings.unKnownError.tr()));
    }
  }
}
