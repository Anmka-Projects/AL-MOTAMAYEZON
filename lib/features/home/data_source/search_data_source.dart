import 'dart:developer';

import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/common/http/params.dart';
import 'package:elmotamizon/features/details/models/course_details_model.dart';

abstract class SearchDataSource {
  Future<Either<Failure, List<CourseModel>>> getSearch(
      PaginationParams params, {
        String? text,
      });
}

class SearchDataSourceImpl implements SearchDataSource {
  final GenericDataSource _genericDataSource;

  SearchDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, List<CourseModel>>> getSearch(
      PaginationParams params, {
        String? text,
      }) async {
    try {
      return await _genericDataSource.fetchData<CourseModel>(
        endpoint: Endpoints.courcesSearch,
        fromJson: CourseModel.fromJson,
        params: params,
        queryParameters: {"q": text},
      );
    } catch (e, stackTrace) {
      log("Search error: ${e.runtimeType} - ${e.toString()}",
          stackTrace: stackTrace);
      return Left(ParsingFailure(message: e.toString()));
    }
  }
}
