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
      final String serialNumber = await _safeGetDeviceId();
      final String normalizedChildCode = childCode?.trim() ?? '';
      if (userType == "parent" && normalizedChildCode.isEmpty) {
        return Left(
          ValidationFailure(
            message: 'Child code is required',
            errors: const ['Child code is required'],
          ),
        );
      }

      FormData formData = FormData.fromMap({
        "name": name.trim(),
        "phone": phone.trim(),
        "email": email.trim(),
        "password": password.trim(),
        "password_confirmation": passwordConfirmation.trim(),
        "user_type": userType,
        "stage_id": stageId,
        "grade_id": gradeId,
        "birth_date": birthDate?.trim(),
        "device_id": serialNumber,
      });

      if (userType == "parent") {
        formData.fields.add(MapEntry('code', normalizedChildCode));
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

  Future<String> _safeGetDeviceId() async {
    try {
      const fallback = 'device_not_have_id';
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        return androidInfo.id;
      }
      if (Platform.isIOS || Platform.isMacOS) {
        final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        return iosInfo.identifierForVendor ?? fallback;
      }
      return fallback;
    } catch (e, stackTrace) {
      log("$stackTrace device id error ${e.toString()}");
      return 'device_not_have_id';
    }
  }
}
