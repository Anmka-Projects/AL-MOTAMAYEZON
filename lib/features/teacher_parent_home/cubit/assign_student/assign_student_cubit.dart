import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/features/teacher_parent_home/data_source/assign_student_data_source.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssignStudentCubit extends Cubit<BaseState<String>> {
  AssignStudentCubit(this._assignStudentDataSource)
      : super(const BaseState<String>());

  final AssignStudentDataSource _assignStudentDataSource;

  Future<void> assignStudent(String code) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _assignStudentDataSource.assignStudent(code);
    result.fold(
          (l) => emit(state.copyWith(
          failure: l, status: Status.failure, errorMessage: l.message)),
          (r) => emit(state.copyWith(status: Status.success,data: r.message)),
    );
  }
}
