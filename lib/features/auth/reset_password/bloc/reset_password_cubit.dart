import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/features/auth/reset_password/data_source/reset_password_data_source.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<BaseState<String>> {
  ResetPasswordCubit(this._resetPasswordDataSource) : super(const BaseState<String>());
  final ResetPasswordDataSource _resetPasswordDataSource;

  Future<void> resetPassword(String phone,String password,String passwordConfirmation) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _resetPasswordDataSource.resetPassword(phone,password,passwordConfirmation);
    result.fold(
            (l) => emit(state.copyWith(failure: l, status: Status.failure, errorMessage: l.message)),
            (r) => emit(state.copyWith(status: Status.success,data: r)));
  }
}
