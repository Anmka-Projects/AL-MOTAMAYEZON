import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/features/details/models/course_or_lesson_or_exam_or_homework_model.dart';
import 'package:elmotamizon/features/teacher_parent_home/data_source/delete_active_course_or_lesson_data_source.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteActiveCourseOrLessonCubit extends Cubit<BaseState<String>> {
  DeleteActiveCourseOrLessonCubit(this._deleteActiveCourseOrLessonDataSource)
      : super(const BaseState<String>());

  final DeleteActiveCourseOrLessonDataSource _deleteActiveCourseOrLessonDataSource;

  Future<void> deleteActiveCourseOrLesson({required int id, required ItemType type, required bool isDelete}) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _deleteActiveCourseOrLessonDataSource.deleteActiveCourseOrLesson(id, type, isDelete);
    result.fold(
          (l) => emit(state.copyWith(
          failure: l, status: Status.failure, errorMessage: l.message)),
          (r) => emit(state.copyWith(status: Status.success,data: r.message)),
    );
  }
}
