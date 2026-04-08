import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/http/pagination_helper.dart';
import 'package:elmotamizon/common/http/params.dart';
import 'package:elmotamizon/features/details/data_source/lessons_data_source.dart';
import 'package:elmotamizon/features/home/details/models/lessons_content_model.dart';
import 'package:elmotamizon/features/lesson_details/models/lesson_details_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Lessons2Cubit extends Cubit<BaseState<Lesson2Model>> {
  Lessons2Cubit(this._coursesDataSource)
      : super(const BaseState<Lesson2Model>()) {
    _paginationHandler = PaginationHandler<Lesson2Model, Lessons2Cubit>(
      bloc: this,
      pageSize: 10,
    );
  }

  final LessonsDataSource _coursesDataSource;
  late final PaginationHandler<Lesson2Model, Lessons2Cubit> _paginationHandler;

  Future<void> loadFirstLessonsPage(int courseId) async {
    await _paginationHandler.loadFirstPage(
      (page, limit, [params]) => _coursesDataSource.getLessons(
          PaginationParams(page: page, limit: limit), courseId),
    );
  }

  Future<void> loadMoreLessonsPage(int courseId) async {
    await _paginationHandler.fetchData(
      (page, limit, [params]) => _coursesDataSource.getLessons(
          PaginationParams(page: page, limit: limit), courseId),
    );
  }
}
