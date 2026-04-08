import 'dart:developer';

import 'package:elmotamizon/common/base/exports.dart';
import 'package:dio/dio.dart';

abstract class AddLessonDataSource {
  Future<Either<Failure, String>> addLesson({
    required String nameAr,
    required String nameEn,
    required int courseId,
    required String imagePath,
    required String videoUrl,
    required List<String> files,
    required List<String> filesNames,
    int? lessonId,
  });
}

class AddLessonDataSourceImpl implements AddLessonDataSource {
  final GenericDataSource _genericDataSource;

  AddLessonDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, String>> addLesson({
    required String nameAr,
    required String nameEn,
    required int courseId,
    required String imagePath,
    required String videoUrl,
    required List<String> files,
    required List<String> filesNames,
    int? lessonId,
  }) async {
    try {
      Map<String, dynamic> data = {
        "name[ar]": nameAr,
        "name[en]": nameEn,
        "course_id": courseId,
        "video_url": videoUrl,
      };

      if(imagePath.isNotEmpty){
        data.addAll({"image" : MultipartFile.fromFileSync(imagePath)});
      }

      for (int i = 0; i < files.length; i++) {
        String key = 'files[$i][file]';
        data[key] = MultipartFile.fromFileSync(files[i]);
        String key2 = 'files[$i][name][ar]';
        data[key2] = filesNames[i];
        String key3 = 'files[$i][name][en]';
        data[key3] = filesNames[i];
      }

      return await _genericDataSource.postFormData<String>(
        endpoint: lessonId != null ? Endpoints.editLesson(lessonId) : Endpoints.addLesson,
        data: data,
      );
    } catch (e, stackTrace) {
      log("Add course error: ${e.runtimeType} - ${e.toString()}", stackTrace: stackTrace);
      return Left(ParsingFailure(message: e.toString()));
    }
  }
}
