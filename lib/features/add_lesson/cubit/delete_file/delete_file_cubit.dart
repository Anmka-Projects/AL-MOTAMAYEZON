import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/features/add_lesson/data_source/delete_file_data_source.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteFileCubit extends Cubit<BaseState<String>> {
  DeleteFileCubit(this._deleteFileDataSource)
      : super(const BaseState<String>());

  final DeleteFileDataSource _deleteFileDataSource;

  Future<void> deleteFile(int id) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _deleteFileDataSource.deleteFile(id);
    result.fold(
          (l) => emit(state.copyWith(
          failure: l, status: Status.failure, errorMessage: l.message)),
          (r) => emit(state.copyWith(status: Status.success,data: r.message)),
    );
  }
}
