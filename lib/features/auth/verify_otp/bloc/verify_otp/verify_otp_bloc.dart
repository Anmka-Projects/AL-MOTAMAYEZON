import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/features/auth/verify_otp/data_source/verify_otp_data_source.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part "verify_otp_state.dart";

class VerifyOtpCubit extends Cubit<BaseState> {
  final VerifyOtpDataSource _verifyOTPDataSource;
  VerifyOtpCubit(this._verifyOTPDataSource) : super(const BaseState());

  Future<void> verifyOtp(String phone, String otp, bool isForgetPassword) async {
    emit(state.copyWith(status: Status.loading));
    final result =await _verifyOTPDataSource.verifyOtp(phone, otp, isForgetPassword);
    result.fold(
          (failure) => emit(state.copyWith(status: Status.failure, failure: failure, errorMessage: failure.message)),
          (success) => emit(state.copyWith(status: Status.success)),
    );
  }
}