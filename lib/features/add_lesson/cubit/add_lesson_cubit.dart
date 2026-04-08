import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/features/add_lesson/data_source/add_lesson_data_source.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddLessonCubit extends Cubit<BaseState<String>> {
  AddLessonCubit(this._addLessonDataSource)
      : super(const BaseState<String>());

  final AddLessonDataSource _addLessonDataSource;

  Future<void> addLesson(
      {
        required String nameAr,
        required String nameEn,
        required int courseId,
        required String imagePath,
        required String videoUrl,
        required List<String> files,
        required List<String> filesNames,
        int? lessonId,
      }
      ) async
  {
    try {
      emit(state.copyWith(status: Status.loading));

      final result = await _addLessonDataSource.addLesson(
          nameAr: nameAr,
          nameEn: nameEn,
          courseId: courseId,
          imagePath: imagePath,
          videoUrl: videoUrl,
          lessonId: lessonId,
          files: files,
        filesNames: filesNames
      );

      result.fold(
            (failure) => emit(
          state.copyWith(
            status: Status.failure,
            errorMessage: failure.message,
            failure: failure,
          ),
        ),
            (message) => emit(
          state.copyWith(
            status: Status.success,
            data: message,
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: Status.failure,
          errorMessage: e.toString(),
          failure: ParsingFailure(message: e.toString()),
        ),
      );
    }
  }
}
