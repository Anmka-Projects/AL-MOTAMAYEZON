import 'dart:developer';

import 'package:elmotamizon/common/base/exports.dart';
import 'package:dio/dio.dart';

abstract class AddCourseDataSource {
  Future<Either<Failure, String>> addCourse({
    required String nameAr,
    required String nameEn,
    required String descriptionAr,
    required String descriptionEn,
    required String whatYouWillLearnAr,
    required String whatYouWillLearnEn,
    required String subjectId,
    required String gradeId,
    required String stageId,
    required String imagePath,
    required String videoUrl,
    required String price,
    int? courseId,
  });
}

class AddCourseDataSourceImpl implements AddCourseDataSource {
  final GenericDataSource _genericDataSource;

  AddCourseDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, String>> addCourse({
    required String nameAr,
    required String nameEn,
    required String descriptionAr,
    required String descriptionEn,
    required String whatYouWillLearnAr,
    required String whatYouWillLearnEn,
    required String subjectId,
    required String gradeId,
    required String stageId,
    required String imagePath,
    required String videoUrl,
    required String price,
    int? courseId,
  }) async {
    try {

      Map<String,dynamic> data = {
        "name[ar]": nameAr,
        "name[en]": nameEn,
        "description[ar]": descriptionAr,
        "description[en]": descriptionEn,
        "what_you_will_learn[ar]": whatYouWillLearnAr,
        "what_you_will_learn[en]": whatYouWillLearnEn,
        "subject_id": subjectId,
        "grade_id": gradeId,
        "stage_id": stageId,
        "price": price,
        "video_url": videoUrl,
      };

      if(imagePath.isNotEmpty){
        data.addAll({"image" : MultipartFile.fromFileSync(imagePath)});
      }

      return await _genericDataSource.postFormData<String>(
        endpoint: courseId != null ? Endpoints.editCourse(courseId) : Endpoints.addCourse,
        data: data,


      );
    } catch (e, stackTrace) {
      log("Add course error: ${e.runtimeType} - ${e.toString()}", stackTrace: stackTrace);
      return Left(ParsingFailure(message: e.toString()));
    }
  }
}
