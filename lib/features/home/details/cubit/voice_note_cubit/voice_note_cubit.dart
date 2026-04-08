import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/http/pagination_helper.dart';
import 'package:elmotamizon/common/http/params.dart';
import 'package:elmotamizon/features/home/details/data_source/voice_note_data_source.dart';
import 'package:elmotamizon/features/home/details/models/voice_note_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VoiceNoteCubit extends Cubit<BaseState<VoiceNoteModel>> {
  VoiceNoteCubit(this._coursesDataSource)
      : super(const BaseState<VoiceNoteModel>()) {
    _paginationHandler = PaginationHandler<VoiceNoteModel, VoiceNoteCubit>(
      bloc: this,
      pageSize: 10,
    );
  }

  final VoiceNoteDataSource _coursesDataSource;
  late final PaginationHandler<VoiceNoteModel, VoiceNoteCubit>
      _paginationHandler;

  Future<void> loadFirstVoiceNotePage(int courseId) async {
    await _paginationHandler.loadFirstPage(
      (page, limit, [params]) => _coursesDataSource.getVoiceNote(
          PaginationParams(page: page, limit: limit), courseId),
    );
  }

  Future<void> loadMoreVoiceNotePage(int courseId) async {
    await _paginationHandler.fetchData(
      (page, limit, [params]) => _coursesDataSource.getVoiceNote(
          PaginationParams(page: page, limit: limit), courseId),
    );
  }

  int get pageSize => _paginationHandler.pageSize;
  bool get hasMore => _paginationHandler.hasMoreData;
}
