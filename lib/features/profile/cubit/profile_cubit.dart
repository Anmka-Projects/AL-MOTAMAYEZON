import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/features/profile/data_source/profile_data_source.dart';
import 'package:elmotamizon/features/profile/models/profile_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._profileDataSource) : super(const ProfileState());
  final ProfileDataSource _profileDataSource;

  Future<void> fetchProfile() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _profileDataSource.getProfile();
    result.fold(
      (failure) => emit(state.copyWith(status: Status.failure, errorMessage: failure.message, failure: failure)),
      (profile) => emit(state.copyWith(status: Status.success, profile: profile)),
    );
  }

  Future<void> updateTeacherProfile({
    required String name,
    required String email,
    required String birthDate,
    String? image,
    String? bio,
    String? qualification,
    int? stageId,
    int? gradeId,
  }) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _profileDataSource.updateTeacherProfile(
      name: name,
      email: email,
      birthDate: birthDate,
      image: image,
      bio: bio,
      qualification: qualification,
      stageId: stageId,
      gradeId: gradeId
    );
    result.fold(
      (failure) => emit(state.copyWith(status: Status.failure, errorMessage: failure.message, failure: failure)),
      (baseModel) => emit(state.copyWith(status: Status.success, message: baseModel.message)),
    );
  }
} 