import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/features/exam_details/data_source/exam_details_data_source.dart';
import 'package:elmotamizon/features/exam_details/models/exam_details_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ExamDetailsCubit extends Cubit<BaseState<ExamDetailsModel>> {
  ExamDetailsCubit(this._courseDetailsDataSource) : super(const BaseState());
  final ExamDetailsDataSource _courseDetailsDataSource;

  Future<void> getExamDetails(int id) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _courseDetailsDataSource.getExamDetails(id);
    result.fold(
          (failure) => emit(state.copyWith(status: Status.failure, failure: failure, errorMessage: failure.message)),
          (success) => emit(state.copyWith(status: Status.success, data: success)),
    );
  }
}
