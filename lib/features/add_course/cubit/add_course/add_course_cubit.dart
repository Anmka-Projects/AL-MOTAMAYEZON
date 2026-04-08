import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/features/add_course/data_source/add_course_data_source.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCourseCubit extends Cubit<BaseState<String>> {
  AddCourseCubit(this._addCourseDataSource)
      : super(const BaseState<String>());

  final AddCourseDataSource _addCourseDataSource;

  Future<void> addCourse(
  {
    required String nameAr,
    required String nameEn,
    required String descriptionAr,
    required String descriptionEn,
    required String whatYouWillLearnAr,
    required String whatYouWillLearnEn,
    required String subjectId,
    required String gradeId,
    required String stageId,
    required String imagePath,
    required String videoUrl,
    required String price,
    int? courseId,
}
      ) async {
    try {
      emit(state.copyWith(status: Status.loading));

      final result = await _addCourseDataSource.addCourse(
          nameAr: nameAr,
          nameEn: nameEn,
          descriptionAr: descriptionAr,
          descriptionEn: descriptionEn,
          whatYouWillLearnAr: whatYouWillLearnAr,
          whatYouWillLearnEn: whatYouWillLearnEn,
          subjectId: subjectId,
          gradeId: gradeId,
          stageId: stageId,
          imagePath: imagePath,
          videoUrl: videoUrl,
          price: price,
          courseId: courseId
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
