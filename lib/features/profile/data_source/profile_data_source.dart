import 'package:elmotamizon/app/app_prefs.dart';
import 'package:elmotamizon/app/imports.dart';
import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/features/profile/models/profile_model.dart';
import 'package:elmotamizon/common/base/base_model.dart';
import 'package:dio/dio.dart';

abstract class ProfileDataSource {
  Future<Either<Failure, ProfileModel>> getProfile();
  Future<Either<Failure, BaseModel>> updateTeacherProfile({
    required String name,
    required String email,
    required String birthDate,
    String? image,
    String? bio,
    String? qualification,
    int? stageId,
    int? gradeId,
  });
}

class ProfileDataSourceImpl implements ProfileDataSource {
  final ApiConsumer _apiConsumer;
  ProfileDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, ProfileModel>> getProfile() async {
    final result = await _apiConsumer.get(Endpoints.userData);
    return result.fold(
      (l) => Left(l),
      (r) => Right(ProfileModel.fromJson(r['data'])),
    );
  }

  @override
  Future<Either<Failure, BaseModel>> updateTeacherProfile({
    required String name,
    required String email,
    required String birthDate,
    String? image,
    String? bio,
    String? qualification,
    int? stageId,
    int? gradeId,
  }) async {
     Map<String, dynamic> dataToSend = {
        'name': name,
        'email': email,
        'birth_date': birthDate,
        if(image != null) 'image': await MultipartFile.fromFile(image),
        if (bio != null) 'bio': bio,
        if (qualification != null) 'qualification': qualification,
        if (stageId != null) 'stage_id': stageId,
       if (gradeId != null) 'grade_id': gradeId
      };

    final result = await _apiConsumer.uploadFile(
      Endpoints.updateTeacherProfile,
      formData: FormData.fromMap(dataToSend),
    );
    return result.fold(
      (l) => Left(l),
      (r) {
        instance<AppPreferences>().saveUserName(r['data']["name"]);
        instance<AppPreferences>().saveUserImage(r['data']["image"]);
        if(r['data']["is_apple_review"] != null) instance<AppPreferences>().saveUserIsAppleReview(r['data']["is_apple_review"]);
           return Right(BaseModel.fromJson(r));
      },
    );
  }
} 