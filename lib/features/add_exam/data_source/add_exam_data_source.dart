import 'dart:developer';

import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/features/exam_details/models/exam_details_model.dart';
import 'package:dio/dio.dart';

abstract class AddExamDataSource {
  Future<Either<Failure, String>> addExam({
    required String nameAr,
    required String nameEn,
    required int lessonId,
    required String imagePath,
    required String duration,
    required List<QuestionModel> questions,
    int? examId,
    int? resourceExamId,
    String? description,
  });
}

class AddExamDataSourceImpl implements AddExamDataSource {
  final GenericDataSource _genericDataSource;

  AddExamDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, String>> addExam({
    required String nameAr,
    required String nameEn,
    required int lessonId,
    required String imagePath,
    required String duration,
    required List<QuestionModel> questions,
    int? examId,
    int? resourceExamId,
    String? description,
  }) async {
    try {
      Map<String, dynamic> data = {};

      if (resourceExamId != null) {
        data["test_id"] = resourceExamId;
        data["lesson_id"] = lessonId;
      }
      else{
        data = {
          "name[ar]": nameAr,
          "name[en]": nameEn,
          "lesson_id": lessonId,
          "duration": duration,
        };

        if (description != null && description.isNotEmpty) {
          data["desc"] = description;
        }



        if(imagePath.isNotEmpty){
          data.addAll({"image" : MultipartFile.fromFileSync(imagePath)});
        }

        for (int i = 0; i < questions.length; i++) {
          String key = 'questions[$i][title]';
          data[key] = questions[i].title;
          if (questions[i].image != null && questions[i].image!.isNotEmpty) {
            data['questions[$i][image]'] = MultipartFile.fromFileSync(questions[i].image!);
          }
          for (int j = 0; j < (questions[i].answers?.length??0); j++) {
            String key2 = 'questions[$i][answers][$j][answer_text]';
            data[key2] = questions[i].answers?[j].answerText;
            String key3 = 'questions[$i][answers][$j][is_correct]';
            data[key3] = questions[i].answers?[j].isCorrect;
          }
        }
      }





      return await _genericDataSource.postFormData<String>(
        endpoint: examId != null ? Endpoints.editExam(examId) : Endpoints.addExam,
        data: data,
      );
    } catch (e, stackTrace) {
      log("Add course error: ${e.runtimeType} - ${e.toString()}", stackTrace: stackTrace);
      return Left(ParsingFailure(message: e.toString()));
    }
  }
}
