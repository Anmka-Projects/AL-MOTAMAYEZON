import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/features/details/data_source/course_details_data_source.dart';
import 'package:elmotamizon/features/details/models/course_details_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourseDetailsCubit2 extends Cubit<BaseState<CourseDetailsModel>> {
  CourseDetailsCubit2(this._courseDetailsDataSource) : super(const BaseState());
  final CourseDetailsDataSource2 _courseDetailsDataSource;

  Future<void> getCourseDetails(String id) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _courseDetailsDataSource.getCourseDetails(id);
    result.fold(
      (failure) => emit(state.copyWith(
          status: Status.failure,
          failure: failure,
          errorMessage: failure.message)),
      (success) => emit(state.copyWith(status: Status.success, data: success)),
    );
  }
}
