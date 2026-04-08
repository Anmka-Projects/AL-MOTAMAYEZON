import 'dart:developer';

import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/common/http/params.dart';
import 'package:elmotamizon/features/my_teachers/model/my_teachers_model.dart';

abstract class MyTeachersDataSource {
  Future<Either<Failure, List<TeacherModel>>> myTeachers(
      PaginationParams params,{bool isAll = false, String? searchText});
}

class MyTeachersDataSourceImpl implements MyTeachersDataSource {
  final GenericDataSource _genericDataSource;

  MyTeachersDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, List<TeacherModel>>> myTeachers(
      PaginationParams params, {bool isAll = false, String? searchText}) async {
    try {
      return await _genericDataSource.fetchData<TeacherModel>(
        endpoint: (searchText??'').isNotEmpty ? Endpoints.search(searchText!) : isAll ? Endpoints.allTeachers : Endpoints.myTeachers,
        fromJson: TeacherModel.fromJson,
        params: params,
      );
    } catch (e, stackTrace) {
      log("teachers error: ${e.runtimeType} - ${e.toString()}",
          stackTrace: stackTrace);
      return Left(ParsingFailure(message: e.toString()));
    }
  }
}
