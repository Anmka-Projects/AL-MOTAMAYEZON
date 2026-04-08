import 'dart:developer';

import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/common/http/params.dart';
import 'package:elmotamizon/features/details/models/course_details_model.dart';

abstract class CoursesDataSource {
  Future<Either<Failure, List<CourseModel>>> getCourses(
    PaginationParams params, {
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
  });
}

class CoursesDataSourceImpl implements CoursesDataSource {
  final GenericDataSource _genericDataSource;

  CoursesDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, List<CourseModel>>> getCourses(
    PaginationParams params, {
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
    try {
      return await _genericDataSource.fetchData<CourseModel>(
        endpoint: isBooks
            ? Endpoints.books
            : isFreeLesson
                ? Endpoints.freeLesson
                : isFavorite
                    ? Endpoints.favorite
                    : isFavoriteBook
                        ? Endpoints.favoriteBook
                        : isSubscribedBooks
                            ? Endpoints.subscribedBooks
                            : isSearch
                                ? Endpoints.courcesSearch
                                : inProgress || isCompleted
                                    ? Endpoints.progress
                                    : Endpoints.courses,
        fromJson: CourseModel.fromJson,
        params: params,
        queryParameters: isSearch
            ? {"q": status, "type": searchType}
            : inProgress || isCompleted
                ? {"status": status}
                : null,
      );
    } catch (e, stackTrace) {
      log("Courses error: ${e.runtimeType} - ${e.toString()}",
          stackTrace: stackTrace);
      return Left(ParsingFailure(message: e.toString()));
    }
  }
}
