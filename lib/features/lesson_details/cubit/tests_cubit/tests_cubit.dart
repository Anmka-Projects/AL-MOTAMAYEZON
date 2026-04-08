import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/http/pagination_helper.dart';
import 'package:elmotamizon/common/http/params.dart';
import 'package:elmotamizon/features/exam_details/models/exam_details_model.dart';
import 'package:elmotamizon/features/lesson_details/data_source/tests_data_source.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TestsCubit extends Cubit<BaseState<ExamModel>> {
  TestsCubit(this._testsDataSource) : super(const BaseState<ExamModel>()) {
    _paginationHandler = PaginationHandler<ExamModel, TestsCubit>(
      bloc: this,
      pageSize: 10,
    );
  }

  final TestsDataSource _testsDataSource;
  late final PaginationHandler<ExamModel, TestsCubit> _paginationHandler;

  Future<void> loadFirstTestsPage(int lessonId, {bool isStudentDetails = false}) async {
    await _paginationHandler.loadFirstPage(
      (page, limit, [params]) => _testsDataSource.getExams(
          PaginationParams(page: page, limit: limit), lessonId, isStudentDetails),
    );
  }

  Future<void> loadMoreTestsPage(int lessonId, {bool isStudentDetails = false}) async {
    await _paginationHandler.fetchData(
      (page, limit, [params]) => _testsDataSource.getExams(
          PaginationParams(page: page, limit: limit), lessonId, isStudentDetails),
    );
  }
}
