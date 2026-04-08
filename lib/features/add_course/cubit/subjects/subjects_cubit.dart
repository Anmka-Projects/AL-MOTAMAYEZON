import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/features/add_course/data_source/subjects_data_source.dart';
import 'package:elmotamizon/features/add_course/models/subjects_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class SubjectsCubit extends Cubit<BaseState<SubjectsModel>> {
  SubjectsCubit(this._subjectsDataSource) : super(const BaseState());
  final SubjectsDataSource _subjectsDataSource;

  Future<void> getSubjects() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _subjectsDataSource.getSubjects();
    result.fold(
          (failure) => emit(state.copyWith(status: Status.failure, failure: failure, errorMessage: failure.message)),
          (success) => emit(state.copyWith(status: Status.success, data: success)),
    );
  }
}
