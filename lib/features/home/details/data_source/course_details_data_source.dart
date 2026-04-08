import 'dart:developer';

import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/features/home/details/models/course_details_model.dart';

abstract class CourseDetailsDataSource {
  Future<Either<Failure, CourseDetailsModel>> getCourseDetails(String id);
}

class CourseDetailsDataSourceImpl implements CourseDetailsDataSource {
  final ApiConsumer _apiConsumer;

  CourseDetailsDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, CourseDetailsModel>> getCourseDetails(
      String id) async {
    try {
      final result = await _apiConsumer.get(
        Endpoints.courseDetails(id),
      );
      return result.fold((l) => Left(l), (r) {
        return Right(CourseDetailsModel.fromJson(r));
      });
    } catch (e, stackTrace) {
      log("$stackTrace login error ${e.toString()}");
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
