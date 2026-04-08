import 'package:elmotamizon/common/base/exports.dart';
import 'package:elmotamizon/features/details/models/course_details_model.dart';
import 'package:elmotamizon/features/exam_details/models/exam_details_model.dart';
import 'package:elmotamizon/features/lesson_details/models/homeworks_model.dart';
import 'package:elmotamizon/features/lesson_details/models/lesson_details_model.dart';

enum ItemType { course, lesson, exam, homework }

class CourseOrLessonOrExamOrHomeworkModel extends Equatable {
  final CourseModel? course;
  final Lesson2Model? lesson;
  final HomeworkModel? homework;
  final ExamModel? exam;

  const CourseOrLessonOrExamOrHomeworkModel(
      {this.course, this.lesson, this.homework, this.exam});

  @override
  List<Object?> get props => [course, lesson, homework, exam];
}
