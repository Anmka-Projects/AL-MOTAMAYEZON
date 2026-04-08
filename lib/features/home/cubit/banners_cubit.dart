import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/features/home/data_source/banners_data_source.dart';
import 'package:elmotamizon/features/home/model/banners_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BannersCubit extends Cubit<BaseState<BannersModel>> {
  BannersCubit(this._onBoardingDataSource) : super(const BaseState<BannersModel>());

  final BannersDataSource _onBoardingDataSource;

  Future<void> getBanners() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _onBoardingDataSource.getBanners();
    result.fold(
          (failure) => emit(state.copyWith(status: Status.failure, failure: failure, errorMessage: failure.message)),
          (success) => emit(state.copyWith(status: Status.success, data: success)),
    );
  }
}
