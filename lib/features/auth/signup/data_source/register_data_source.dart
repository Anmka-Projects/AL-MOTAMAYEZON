import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/features/auth/signup/models/signup_model.dart';
import 'package:dio/dio.dart';

abstract class RegisterDataSource {
  Future<Either<Failure, SignupModel>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
    required String userType,
    int? stageId,
    int? gradeId,
    String? imagePath,
    String? birthDate,
    String? childCode,
  });
}

class RegisterDataSourceImpl implements RegisterDataSource {
  final ApiConsumer _apiConsumer;

  RegisterDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, SignupModel>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
    required String userType,
    int? stageId,
    int? gradeId,
    String? imagePath,
    String? birthDate,
    String? childCode,
  }) async {
    try {
      String serialNumber = '';
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        serialNumber = androidInfo.id;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        serialNumber = iosInfo.identifierForVendor ?? 'device not have id';
      }
      FormData formData = FormData.fromMap({
        "name": name,
        "phone": phone,
        "email": email,
        "password": password,
        "password_confirmation": passwordConfirmation,
        "user_type": userType,
        "stage_id": stageId,
        "grade_id": gradeId,
        "birth_date": birthDate,
        "device_id": serialNumber,
      });

      if (userType == "parent") {
        formData.fields.add(MapEntry('code', childCode!));
      }

      if (imagePath != null) {
        formData.files
            .add(MapEntry('image', MultipartFile.fromFileSync(imagePath)));
      }

      final result = await _apiConsumer.uploadFile(
        Endpoints.register,
        formData: formData,
      );
      log('Register API response: $result');
      return result.fold((l) => Left(l), (r) {
        log('Register API success payload: $r');
        return Right(SignupModel.fromJson(r));
      });
    } catch (e, stackTrace) {
      log("$stackTrace login error ${e.toString()}");
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
