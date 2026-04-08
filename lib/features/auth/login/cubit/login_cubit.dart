import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/features/auth/login/data_source/login_data_source.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._loginDataSource) : super(const LoginState());
  final LoginDataSource _loginDataSource;

  Future<void> login(String email, String password) async {
    emit(state.copyWith(status: Status.loading));
    final result =await _loginDataSource.login(email, password);
    result.fold(
          (failure) => emit(state.copyWith(status: Status.failure, failure: failure, errorMessage: failure.message)),
          (success) => emit(state.copyWith(status: Status.success)),
    );
  }
}
