import 'dart:developer';

import 'package:elmotamizon/common/base/exports.dart';
import 'package:dio/dio.dart';

abstract class AddHomeworkDataSource {
  Future<Either<Failure, String>> addHomework({
    required String nameAr,
    required String nameEn,
    required int lessonId,
    required String imagePath,
    required List<String> files,
  });
}

class AddHomeworkDataSourceImpl implements AddHomeworkDataSource {
  final GenericDataSource _genericDataSource;

  AddHomeworkDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, String>> addHomework({
    required String nameAr,
    required String nameEn,
    required int lessonId,
    required String imagePath,
    required List<String> files,
  }) async {
    try {
      Map<String, dynamic> data = {
        "name[ar]": nameAr,
        "name[en]": nameEn,
        "lesson_id": lessonId,
      };

      if(imagePath.isNotEmpty){
        data.addAll({"image" : MultipartFile.fromFileSync(imagePath)});
      }

      for (int i = 0; i < files.length; i++) {
        String key = 'files[$i][file]';
        data[key] = MultipartFile.fromFileSync(files[i]);
      }

      return await _genericDataSource.postFormData<String>(
        endpoint: Endpoints.addHomework,
        data: data,
      );
    } catch (e, stackTrace) {
      log("Add course error: ${e.runtimeType} - ${e.toString()}", stackTrace: stackTrace);
      return Left(ParsingFailure(message: e.toString()));
    }
  }
}
