import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/features/home/details/data_source/teacher_data_data_source.dart';
import 'package:elmotamizon/features/home/details/models/teacher_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherCubit extends Cubit<BaseState<TeacherDetailsModel>> {
  TeacherCubit(this._teacherDataSource) : super(const BaseState());
  final TeacherDataSource _teacherDataSource;

  Future<void> getTeacher() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _teacherDataSource.getTeacher();
    result.fold(
      (failure) => emit(state.copyWith(
          status: Status.failure,
          failure: failure,
          errorMessage: failure.message)),
      (success) => emit(state.copyWith(status: Status.success, data: success)),
    );
  }
}
