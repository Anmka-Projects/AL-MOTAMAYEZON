import 'package:elmotamizon/common/base/base_state.dart';
import 'package:elmotamizon/common/http/pagination_helper.dart';
import 'package:elmotamizon/common/http/params.dart';
import 'package:elmotamizon/features/homework_details/data_source/submissions_homeworks_data_source.dart';
import 'package:elmotamizon/features/homework_details/models/submissions_homeworks.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubmissionsHomeworksCubit extends Cubit<BaseState<SubmissionHomeworkModel>> {
  SubmissionsHomeworksCubit(this._submissionsHomeworksDataSource)
      : super(const BaseState<SubmissionHomeworkModel>()) {
    _paginationHandler = PaginationHandler<SubmissionHomeworkModel, SubmissionsHomeworksCubit>(
      bloc: this,
      pageSize: 10,
    );
  }

  final SubmissionsHomeworksDataSource _submissionsHomeworksDataSource;
  late final PaginationHandler<SubmissionHomeworkModel, SubmissionsHomeworksCubit> _paginationHandler;

  Future<void> loadFirstSubmissionsHomeworksPage(int homeworkId) async {
    await _paginationHandler.loadFirstPage(
          (page, limit, [params]) => _submissionsHomeworksDataSource
          .submissionsHomeworks(PaginationParams(page: page, limit: limit), homeworkId),
    );
  }

  Future<void> loadMoreSubmissionsHomeworksPage(int homeworkId) async {
    await _paginationHandler.fetchData(
          (page, limit, [params]) => _submissionsHomeworksDataSource
          .submissionsHomeworks(PaginationParams(page: page, limit: limit), homeworkId),
    );
  }
}
