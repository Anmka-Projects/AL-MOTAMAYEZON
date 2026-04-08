import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/features/auth/forget_password/data_source/forget_password_data_source.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordCubit(this._forgetPasswordDataSource) : super(const ForgetPasswordState());
  final ForgetPasswordDataSource _forgetPasswordDataSource;

  Future<void> forgetPassword(String phone) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _forgetPasswordDataSource.forgetPassword(phone);
    result.fold(
            (l) => emit(state.copyWith(failure: l, status: Status.failure, errorMessage: l.message)),
            (r) => emit(state.copyWith(status: Status.success)));
  }
}
