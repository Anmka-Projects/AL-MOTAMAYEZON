import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/features/details/data_source/subscribe_teacher_data_source.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class SubscribeTeacherCubit extends Cubit<BaseState<String>> {
  SubscribeTeacherCubit(this._courseDetailsDataSource) : super(const BaseState<String>());
  final SubscribeTeacherDataSource _courseDetailsDataSource;

  Future<void> subscribeTeacher({
    required int teacherId,
    bool isBook = false,
  }) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _courseDetailsDataSource.subscribeTeacher(teacherId: teacherId, isBook: isBook);
    result.fold(
          (failure) => emit(state.copyWith(status: Status.failure, failure: failure, errorMessage: failure.message)),
          (success) => emit(state.copyWith(status: Status.success, data: success)),
    );
  }
}
