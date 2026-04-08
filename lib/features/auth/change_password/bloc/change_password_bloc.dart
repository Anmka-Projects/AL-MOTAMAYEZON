import 'package:elmotamizon/common/base/base_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data_source/change_password_data_source.dart';

class ChangePasswordBloc extends Cubit<BaseState<void>> {
  final ChangePasswordDataSource changePasswordDataSource;
  void changePassword(String oldPassword, String newPassword) async {
    emit(state.copyWith(status: Status.loading));
    final response = await changePasswordDataSource.changePassword(oldPassword, newPassword);
    response.fold(
      (failure) => emit(state.copyWith(status: Status.failure, failure: failure, errorMessage: failure.message)),
      (success) => emit(state.copyWith(status: Status.success)),
    );
  }
  ChangePasswordBloc(this.changePasswordDataSource) : super(const BaseState());
}