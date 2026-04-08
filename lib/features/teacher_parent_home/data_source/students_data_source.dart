import 'dart:developer';

import 'package:elmotamizon/app/app_prefs.dart';
import 'package:elmotamizon/app/imports.dart';
import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/common/http/params.dart';
import 'package:elmotamizon/features/teacher_parent_home/models/students_model.dart';

abstract class StudentsDataSource {
  Future<Either<Failure, List<StudentModel>>> getStudents(PaginationParams params, {String? searchText});
}

class StudentsDataSourceImpl implements StudentsDataSource {
  final GenericDataSource _apiConsumer;

  StudentsDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, List<StudentModel>>> getStudents(PaginationParams params, {String? searchText}) async {
    try {
      return await _apiConsumer.fetchData<StudentModel>(
          endpoint: (searchText??'').isNotEmpty ? Endpoints.search(searchText!) : instance<AppPreferences>().getUserType() == "teacher" ? Endpoints.teacherStudents : Endpoints.parentStudents,fromJson: StudentModel.fromJson, params: params);
    } catch (e, stackTrace) {
      log("Students error: ${e.runtimeType} - ${e.toString()}", stackTrace: stackTrace);
      return Left(ParsingFailure(message: e.toString()));
    }
  }
}
