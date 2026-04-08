import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/http/pagination_helper.dart';
import 'package:elmotamizon/common/http/params.dart';
import 'package:elmotamizon/features/details/models/course_details_model.dart';
import 'package:elmotamizon/features/home/data_source/search_data_source.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchCubit extends Cubit<BaseState<CourseModel>> {
  SearchCubit(this._searchDataSource)
      : super(const BaseState<CourseModel>()) {
    _paginationHandler = PaginationHandler<CourseModel, SearchCubit>(
      bloc: this,
      pageSize: 10,
    );
  }

  final SearchDataSource _searchDataSource;
  late final PaginationHandler<CourseModel, SearchCubit> _paginationHandler;

  Future<void> loadFirstSearchPage({
    String? text,
  }) async {
    await _paginationHandler.loadFirstPage(
          (page, limit, [params]) => _searchDataSource.getSearch(
        text: text,
        PaginationParams(page: page, limit: limit),
      ),
    );
  }

  Future<void> loadMoreSearchPage({
    int? teacherId,
    bool isFavorite = false,
    bool isFavoriteBook = false,
    bool isCompleted = false,
    bool inProgress = false,
    bool isFreeLesson = false,
    bool isBooks = false,
    String? text,
  }) async {
    await _paginationHandler.fetchData(
          (page, limit, [params]) => _searchDataSource.getSearch(
        text: text,
        PaginationParams(page: page, limit: limit),
      ),
    );
  }
}
