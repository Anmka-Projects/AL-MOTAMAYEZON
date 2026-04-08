import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/http/pagination_helper.dart';
import 'package:elmotamizon/common/http/params.dart';
import 'package:elmotamizon/features/exam_details/data_source/exam_submissions_data_source.dart';
import 'package:elmotamizon/features/exam_details/models/exam_submission_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExamSubmissionsCubit extends Cubit<BaseState<ExamSubmissionModel>> {
  ExamSubmissionsCubit(this._dataSource)
      : super(const BaseState<ExamSubmissionModel>()) {
    _paginationHandler = PaginationHandler<ExamSubmissionModel, ExamSubmissionsCubit>(
      bloc: this,
      pageSize: 10,
    );
  }

  final ExamSubmissionsDataSource _dataSource;
  late final PaginationHandler<ExamSubmissionModel, ExamSubmissionsCubit> _paginationHandler;

  Future<void> loadFirstExamSubmissionsPage({required int examId}) async {
    await _paginationHandler.loadFirstPage(
      (page, limit, [params]) => _dataSource.getExamSubmissions(
       examId,
        PaginationParams(page: page, limit: limit),
      ),
    );
  }

  Future<void> loadMoreExamSubmissionsPage({required int examId}) async {
    await _paginationHandler.fetchData(
      (page, limit, [params]) => _dataSource.getExamSubmissions(
        examId,
        PaginationParams(page: page, limit: limit),
      ),
    );
  }
} 