import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/features/teacher_parent_home/data_source/students_data_source.dart';
import 'package:elmotamizon/features/teacher_parent_home/models/students_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/http/pagination_helper.dart';
import '../../../../common/http/params.dart';

part 'students_state.dart';

class StudentsCubit extends Cubit<BaseState<StudentModel>> {
  StudentsCubit(this._assignStudentDataSource) : super(const BaseState<StudentModel>()){
    _paginationHandler = PaginationHandler<StudentModel,  StudentsCubit>(
         bloc: this,pageSize: 10,);
  }
  final StudentsDataSource _assignStudentDataSource;
  late final   PaginationHandler<StudentModel,  StudentsCubit> _paginationHandler;
  String? searchText;

  Future<void> loadFirstStudentsPage() async {
    await _paginationHandler.loadFirstPage((page, limit, [params])=> _assignStudentDataSource.getStudents(PaginationParams(page: page, limit: limit ),searchText: searchText));
  }

  Future<void> loadMoreStudentsPage() async {
    await _paginationHandler.fetchData((page, limit, [params])=> _assignStudentDataSource.getStudents(PaginationParams(page: page, limit: limit ),searchText: searchText));
  }
}
