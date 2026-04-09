import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/features/home/details/data_source/view_video_data_source.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewVideoCubit extends Cubit<BaseState> {
  ViewVideoCubit(this._viewVideoDataSource) : super(const BaseState());
  final ViewVideoDataSource _viewVideoDataSource;

  void resetToInitial() {
    if (isClosed) return;
    emit(const BaseState());
  }

  Future<void> viewVideo(int id) async {
    if (isClosed) return;
    emit(state.copyWith(status: Status.loading));
    final result = await _viewVideoDataSource.viewVideo(id);
    if (isClosed) return;
    result.fold(
      (failure) {
        if (isClosed) return;
        emit(state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message));
      },
      (success) {
        if (isClosed) return;
        emit(state.copyWith(
          status: Status.success,
        ));
      },
    );
    if (isClosed) return;
    emit(const BaseState());
  }
}
