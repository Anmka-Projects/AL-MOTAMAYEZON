import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/features/auth/signup/data_source/stages_grades_data_source.dart';
import 'package:elmotamizon/features/auth/signup/models/stages_grades_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'stages_grades_state.dart';

class StagesGradesCubit extends Cubit<BaseState<StagesGradesModel>> {
  StagesGradesCubit(this._stagesGradesDataSource) : super(const BaseState());
  final StagesGradesDataSource _stagesGradesDataSource;

  Future<void> getStagesGrades() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _stagesGradesDataSource.getStagesGrades();
    result.fold(
      (failure) => emit(state.copyWith(status: Status.failure, failure: failure, errorMessage: failure.message)),
      (success) => emit(state.copyWith(status: Status.success, data: success)),
    );
  }
}
