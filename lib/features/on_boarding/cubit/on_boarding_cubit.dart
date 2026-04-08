import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/resources/assets_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/features/on_boarding/data_source/on_boaeding_data_source.dart';
import 'package:elmotamizon/features/on_boarding/model/on_boarding_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'on_boarding_state.dart';

class OnBoardingCubit extends Cubit<BaseState<OnBoardingModel>> {
  OnBoardingCubit(this._onBoardingDataSource) : super(const BaseState<OnBoardingModel>());
  PageController onBoardingController = PageController();

  final OnBoardingDataSource _onBoardingDataSource;

  Future<void> getOnBoarding() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _onBoardingDataSource.getOnBoarding();
    result.fold(
          (failure) {
            goNext(0, 1);
            return emit(state.copyWith(status: Status.failure, failure: failure, errorMessage: failure.message));
          },
          (success) {
            goNext(0, success.data.length);
            return emit(state.copyWith(status: Status.success, data: success));
          },
    );
  }

  bool isLast = false;

  goNext(int index,int length) {
    print(length);
    print(index);
    emit(UpdateOnBoardingLoadingState());
    if (index == length - 1) {
      isLast = true;
    } else {
      isLast = false;
    }
    emit(UpdateOnBoardingState());
  }
}
