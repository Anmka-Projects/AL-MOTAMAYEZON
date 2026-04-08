import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/http/pagination_helper.dart';
import 'package:elmotamizon/common/http/params.dart';
import 'package:elmotamizon/features/details/models/course_details_model.dart';
import 'package:elmotamizon/features/teacher_parent_home/data_source/courses_data_source.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoursesCubit extends Cubit<BaseState<CourseModel>> {
  CoursesCubit(this._coursesDataSource)
      : super(const BaseState<CourseModel>()) {
    _paginationHandler = PaginationHandler<CourseModel, CoursesCubit>(
      bloc: this,
      pageSize: 10,
    );
  }

  final CoursesDataSource _coursesDataSource;
  late final PaginationHandler<CourseModel, CoursesCubit> _paginationHandler;

  Future<void> loadFirstCoursesPage({
    int? teacherId,
    bool isFavorite = false,
    bool isFavoriteBook = false,
    bool isCompleted = false,
    bool inProgress = false,
    bool isFreeLesson = false,
    bool isBooks = false,
    bool isSubscribedBooks = false,
    bool isSearch = false,
    String? status,
    searchType,
  }) async {
    await _paginationHandler.loadFirstPage(
      (page, limit, [params]) => _coursesDataSource.getCourses(
        teacherId: teacherId,
        isFavorite: isFavorite,
        isFavoriteBook: isFavoriteBook,
        isCompleted: isCompleted,
        inProgress: inProgress,
        isFreeLesson: isFreeLesson,
        isBooks: isBooks,
        status: status,
        searchType: searchType,
        isSubscribedBooks: isSubscribedBooks,
        isSearch: isSearch,
        PaginationParams(page: page, limit: limit),
      ),
    );
  }

  Future<void> loadMoreCoursesPage({
    int? teacherId,
    bool isFavorite = false,
    bool isFavoriteBook = false,
    bool isCompleted = false,
    bool inProgress = false,
    bool isFreeLesson = false,
    bool isBooks = false,
    String? status,
    searchType,
    bool isSubscribedBooks = false,
    bool isSearch = false,
  }) async {
    await _paginationHandler.fetchData(
      (page, limit, [params]) => _coursesDataSource.getCourses(
        teacherId: teacherId,
        isFavorite: isFavorite,
        isFavoriteBook: isFavoriteBook,
        isCompleted: isCompleted,
        inProgress: inProgress,
        isFreeLesson: isFreeLesson,
        isBooks: isBooks,
        status: status,
        searchType: searchType,
        isSubscribedBooks: isSubscribedBooks,
        isSearch: isSearch,
        PaginationParams(page: page, limit: limit),
      ),
    );
  }
}
