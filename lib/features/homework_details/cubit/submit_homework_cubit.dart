import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/features/homework_details/data_source/submit_homework_data_source.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubmitHomeworkCubit extends Cubit<BaseState<String>> {
  SubmitHomeworkCubit(this._submitHomeworkDataSource)
      : super(const BaseState<String>());

  final SubmitHomeworkDataSource _submitHomeworkDataSource;

  Future<void> submitHomework(
      {
        required List<String> files,
        required int homeworkId,
      }
      ) async
  {
    try {
      emit(state.copyWith(status: Status.loading));

      final result = await _submitHomeworkDataSource.submitHomework(
          homeworkId: homeworkId,
          files: files,
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
