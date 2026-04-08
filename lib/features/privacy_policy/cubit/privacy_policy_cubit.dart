import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/features/privacy_policy/data_source/privacy_policy_data_source.dart';
import 'package:elmotamizon/features/privacy_policy/models/privacy_policy_model.dart';
import 'package:elmotamizon/features/privacy_policy/view/privacy_policy_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class PrivacyPolicyCubit extends Cubit<BaseState<PrivacyPolicyModel>> {
  PrivacyPolicyCubit(this._privacyPolicyDataSource) : super(const BaseState<PrivacyPolicyModel>());
  final PrivacyPolicyDataSource _privacyPolicyDataSource;

  Future<void> privacyPolicy({
    required InfoType type,
}) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _privacyPolicyDataSource.getPrivacyPolicy(type: type);
    result.fold(
          (failure) => emit(state.copyWith(status: Status.failure, failure: failure, errorMessage: failure.message)),
          (success) => emit(state.copyWith(status: Status.success,data: success)),
    );
  }
}