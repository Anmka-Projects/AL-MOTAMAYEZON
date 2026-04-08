import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/features/auth/verify_otp/data_source/resend_otp_data_source.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'resend_otp_state.dart';

class ResendOtpCubit extends Cubit<BaseState<String>> {
  ResendOtpCubit(this._resendOtpDataSource) : super(const BaseState<String>());
  final ResendOtpDataSource _resendOtpDataSource;

  Future<void> resendOtp(String phone, bool isForgetPassword) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _resendOtpDataSource.resendOtp(phone, isForgetPassword);
    result.fold(
      (l) => emit(state.copyWith(failure: l, status: Status.failure,errorMessage: l.message)),
      (r) => emit(state.copyWith(status: Status.success,data: r)),
    );
  }
}
