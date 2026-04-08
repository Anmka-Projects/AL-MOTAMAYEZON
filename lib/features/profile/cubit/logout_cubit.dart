import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/features/profile/data_source/logout_data_source.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  LogoutCubit(this._logoutDataSource) : super(const LogoutState());
  final LogoutDataSource _logoutDataSource;

  Future<void> logout({bool isDelete = false}) async {
    isDelete ? emit(state.copyWith(status: Status.custom)) : emit(state.copyWith(status: Status.loading));
    final result = await _logoutDataSource.logout(isDelete: isDelete);
    result.fold(
      (failure) => emit(state.copyWith(status: Status.failure, failure: failure, errorMessage: failure.message)),
      (success) => emit(state.copyWith(status: Status.success)),
    );
  }
} 