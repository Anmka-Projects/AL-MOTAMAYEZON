import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/http/pagination_helper.dart';
import 'package:elmotamizon/common/http/params.dart';
import 'package:elmotamizon/features/my_teachers/data_source/my_teachers_data_source.dart';
import 'package:elmotamizon/features/my_teachers/model/my_teachers_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyTeachersCubit extends Cubit<BaseState<TeacherModel>> {
  MyTeachersCubit(this._myTeachersDataSource)
      : super(const BaseState<TeacherModel>()) {
    _paginationHandler = PaginationHandler<TeacherModel, MyTeachersCubit>(
      bloc: this,
      pageSize: 10,
    );
  }

  String? searchText;

  final MyTeachersDataSource _myTeachersDataSource;
  late final PaginationHandler<TeacherModel, MyTeachersCubit> _paginationHandler;

  Future<void> loadFirstMyTeachersPage({
    bool isAll = false,
}) async {
    await _paginationHandler.loadFirstPage(
      (page, limit, [params]) => _myTeachersDataSource
          .myTeachers(PaginationParams(page: page, limit: limit), isAll: isAll, searchText: searchText),
    );
  }

  Future<void> loadMoreMyTeachersPage({
    bool isAll = false,
  }) async {
    await _paginationHandler.fetchData(
      (page, limit, [params]) => _myTeachersDataSource
          .myTeachers(PaginationParams(page: page, limit: limit),isAll: isAll, searchText: searchText),
    );
  }
}
