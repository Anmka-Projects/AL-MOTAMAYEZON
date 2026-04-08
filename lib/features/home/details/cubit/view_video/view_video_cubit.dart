import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/features/home/details/data_source/view_video_data_source.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewVideoCubit extends Cubit<BaseState> {
  ViewVideoCubit(this._viewVideoDataSource) : super(const BaseState());
  final ViewVideoDataSource _viewVideoDataSource;

  Future<void> viewVideo(int id) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _viewVideoDataSource.viewVideo(id);
    result.fold(
          (failure) => emit(state.copyWith(
          status: Status.failure,
          failure: failure,
          errorMessage: failure.message)),
          (success) => emit(state.copyWith(status: Status.success,)),
    );
  }
}
