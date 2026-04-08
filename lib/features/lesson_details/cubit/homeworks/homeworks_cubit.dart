import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/http/pagination_helper.dart';
import 'package:elmotamizon/common/http/params.dart';
import 'package:elmotamizon/features/lesson_details/data_source/homeworks_data_source.dart';
import 'package:elmotamizon/features/lesson_details/models/homeworks_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeworksCubit extends Cubit<BaseState<HomeworkModel>> {
  HomeworksCubit(this._coursesDataSource) : super(const BaseState<HomeworkModel>()) {
    _paginationHandler = PaginationHandler<HomeworkModel, HomeworksCubit>(
      bloc: this,
      pageSize: 10,
    );
  }

  final HomeworksDataSource _coursesDataSource;
  late final PaginationHandler<HomeworkModel, HomeworksCubit> _paginationHandler;

  Future<void> loadFirstHomeworksPage(int lessonId, {bool isStudentDetails = false}) async {
    await _paginationHandler.loadFirstPage(
          (page, limit, [params]) => _coursesDataSource.getHomeworks(
          PaginationParams(page: page, limit: limit),
          lessonId, isStudentDetails
      ),
    );
  }

  Future<void> loadMoreHomeworksPage(int lessonId, {bool isStudentDetails = false}) async {
    await _paginationHandler.fetchData(
          (page, limit, [params]) => _coursesDataSource.getHomeworks(
          PaginationParams(page: page, limit: limit),lessonId, isStudentDetails
      ),
    );
  }
}
