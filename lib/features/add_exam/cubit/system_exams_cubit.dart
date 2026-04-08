import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/http/pagination_helper.dart';
import 'package:elmotamizon/common/http/params.dart';
import 'package:elmotamizon/features/add_exam/data_source/system_exams_data_source.dart';
import 'package:elmotamizon/features/exam_details/models/exam_details_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SystemExamsCubit extends Cubit<BaseState<ExamModel>> {
  SystemExamsCubit(this._testsDataSource) : super(const BaseState<ExamModel>()) {
    _paginationHandler = PaginationHandler<ExamModel, SystemExamsCubit>(
      bloc: this,
      pageSize: 10,
    );
  }

  final SystemExamsDataSource _testsDataSource;
  late final PaginationHandler<ExamModel, SystemExamsCubit> _paginationHandler;

  Future<void> loadFirstSystemExamsPage(int lessonId) async {
    await _paginationHandler.loadFirstPage(
          (page, limit, [params]) => _testsDataSource.getSystemExams(
          PaginationParams(page: page, limit: limit), lessonId),
    );
  }

  Future<void> loadMoreTestPage(int lessonId) async {
    await _paginationHandler.fetchData(
          (page, limit, [params]) => _testsDataSource.getSystemExams(
          PaginationParams(page: page, limit: limit), lessonId),
    );
  }
}
