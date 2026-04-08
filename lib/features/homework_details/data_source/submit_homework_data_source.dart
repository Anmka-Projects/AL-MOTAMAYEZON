import 'dart:developer';

import 'package:elmotamizon/common/base/exports.dart';
import 'package:dio/dio.dart';

abstract class SubmitHomeworkDataSource {
  Future<Either<Failure, String>> submitHomework({
    required List<String> files,
    required int homeworkId,
  });
}

class SubmitHomeworkDataSourceImpl implements SubmitHomeworkDataSource {
  final GenericDataSource _genericDataSource;

  SubmitHomeworkDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, String>> submitHomework({
    required List<String> files,
    required int homeworkId,
  }) async {
    try {
      Map<String, dynamic> data = {
        "homework_id": homeworkId,
      };

      for (int i = 0; i < files.length; i++) {
        String key = 'files[$i]';
        data[key] = MultipartFile.fromFileSync(files[i]);
      }

      return await _genericDataSource.postFormData<String>(
        endpoint: Endpoints.submitHomework,
        data: data,
      );
    } catch (e, stackTrace) {
      log("Add course error: ${e.runtimeType} - ${e.toString()}", stackTrace: stackTrace);
      return Left(ParsingFailure(message: e.toString()));
    }
  }
}
