import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/features/add_homework/data_source/add_homework_data_source.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddHomeworkCubit extends Cubit<BaseState<String>> {
  AddHomeworkCubit(this._addHomeworkDataSource)
      : super(const BaseState<String>());

  final AddHomeworkDataSource _addHomeworkDataSource;

  Future<void> addHomework(
      {
        required String nameAr,
        required String nameEn,
        required int lessonId,
        required String imagePath,
        required List<String> files,
      }
      ) async {
    try {
      emit(state.copyWith(status: Status.loading));

      final result = await _addHomeworkDataSource.addHomework(
          nameAr: nameAr,
          nameEn: nameEn,
          imagePath: imagePath,
          files: files, lessonId: lessonId,
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
