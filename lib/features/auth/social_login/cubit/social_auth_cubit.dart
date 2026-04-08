import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/features/auth/social_login/data_source/social_auth_data_source.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'social_auth_state.dart';

class SocialAuthCubit extends Cubit<BaseState<void>> {
  SocialAuthCubit(this._socialAuthDataSource) : super(const BaseState());
  final SocialAuthDataSource _socialAuthDataSource;

}
