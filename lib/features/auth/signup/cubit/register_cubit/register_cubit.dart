import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/features/auth/signup/data_source/register_data_source.dart';
import 'package:elmotamizon/features/auth/signup/models/signup_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<BaseState<SignupModel>> {
  RegisterCubit(this._registerDataSource)
      : super(const BaseState<SignupModel>());
  final RegisterDataSource _registerDataSource;

  Future<void> register({
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
    emit(state.copyWith(status: Status.loading));
    final result = await _registerDataSource.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
        passwordConfirmation: passwordConfirmation,
        userType: userType,
        stageId: stageId,
        gradeId: gradeId,
        imagePath: imagePath,
        birthDate: birthDate,
        childCode: childCode);
    result.fold(
      (failure) => emit(state.copyWith(
          status: Status.failure,
          failure: failure,
          errorMessage: failure.message)),
      (success) => emit(state.copyWith(status: Status.success, data: success)),
    );
  }
}
