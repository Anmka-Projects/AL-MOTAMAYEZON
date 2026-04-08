import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/http/pagination_helper.dart';
import 'package:elmotamizon/common/http/params.dart';
import 'package:elmotamizon/features/home/details/data_source/lessons_content_data_source.dart';
import 'package:elmotamizon/features/home/details/models/lessons_content_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LessonsContentCubit extends Cubit<BaseState<LessonModel>> {
  LessonsContentCubit(this._coursesDataSource)
      : super(const BaseState<LessonModel>()) {
    _paginationHandler = PaginationHandler<LessonModel, LessonsContentCubit>(
      bloc: this,
      pageSize: 10,
    );
  }

  final LessonsContentDataSource _coursesDataSource;
  late final PaginationHandler<LessonModel, LessonsContentCubit>
      _paginationHandler;

  Future<void> loadFirstLessonsContentPage(int courseId) async {
    await _paginationHandler.loadFirstPage(
      (page, limit, [params]) => _coursesDataSource.getLessonsContent(
          PaginationParams(page: page, limit: limit), courseId),
    );
  }

  Future<void> loadMoreLessonsContentPage(int courseId) async {
    await _paginationHandler.fetchData(
      (page, limit, [params]) => _coursesDataSource.getLessonsContent(
          PaginationParams(page: page, limit: limit), courseId),
    );
  }

  int get pageSize => _paginationHandler.pageSize;
  bool get hasMore => _paginationHandler.hasMoreData;
}
