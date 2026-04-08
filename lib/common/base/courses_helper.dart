import 'dart:developer';

import 'package:elmotamizon/common/base/courses_type.dart';

bool coursesTypeToParams(CoursesType? type) {
  log("coursesTypeToParams: $type");
  switch (type) {
    case CoursesType.isFavorite:
      return true;
    case CoursesType.isCompleted:
      return true;
    case CoursesType.inProgress:
      return true;
    case CoursesType.isFreeLesson:
      return true;
    case CoursesType.isBooks:
      return true;
    default:
      return false;
  }
}
