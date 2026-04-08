import 'dart:developer';

import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/common/http/params.dart';
import 'package:elmotamizon/features/homework_details/models/submissions_homeworks.dart';

abstract class SubmissionsHomeworksDataSource {
  Future<Either<Failure, List<SubmissionHomeworkModel>>> submissionsHomeworks(
      PaginationParams params,int homeworkId);
}

class SubmissionsHomeworksDataSourceImpl implements SubmissionsHomeworksDataSource {
  final GenericDataSource _genericDataSource;

  SubmissionsHomeworksDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, List<SubmissionHomeworkModel>>> submissionsHomeworks(
      PaginationParams params,int homeworkId) async {
    try {
      return await _genericDataSource.fetchData<SubmissionHomeworkModel>(
        endpoint: Endpoints.submissionsHomework(homeworkId),
        fromJson: SubmissionHomeworkModel.fromJson,
        params: params,
      );
    } catch (e, stackTrace) {
      log("teachers error: ${e.runtimeType} - ${e.toString()}",
          stackTrace: stackTrace);
      return Left(ParsingFailure(message: e.toString()));
    }
  }
}
