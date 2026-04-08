import 'dart:developer';

import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/common/http/params.dart';
import 'package:elmotamizon/features/home/details/models/book_model.dart';

abstract class BooksDataSource {
  Future<Either<Failure, List<BookModel>>> getBooks(
      PaginationParams params, int courseId);
}

class BooksDataSourceImpl implements BooksDataSource {
  final GenericDataSource _genericDataSource;

  BooksDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, List<BookModel>>> getBooks(
      PaginationParams params, int courseId) async {
    try {
      return await _genericDataSource.fetchData<BookModel>(
        endpoint: Endpoints.booksInCourse(courseId),
        fromJson: BookModel.fromJson,
        params: params,
      );
    } catch (e, stackTrace) {
      log("Books error: ${e.runtimeType} - ${e.toString()}",
          stackTrace: stackTrace);
      return Left(ParsingFailure(message: e.toString()));
    }
  }
}
