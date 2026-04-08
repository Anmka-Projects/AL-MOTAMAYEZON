import 'package:elmotamizon/features/lesson_details/models/lesson_details_model.dart';
import 'package:equatable/equatable.dart';

class SubmissionsHomeworksModel extends Equatable {
  const SubmissionsHomeworksModel({
    required this.code,
    required this.message,
    required this.data,
    required this.pagination,
  });

  final int? code;
  final String? message;
  final List<SubmissionHomeworkModel> data;
  final SubmissionsHomeworksPaginationModel? pagination;

  SubmissionsHomeworksModel copyWith({
    int? code,
    String? message,
    List<SubmissionHomeworkModel>? data,
    SubmissionsHomeworksPaginationModel? pagination,
  }) {
    return SubmissionsHomeworksModel(
      code: code ?? this.code,
      message: message ?? this.message,
      data: data ?? this.data,
      pagination: pagination ?? this.pagination,
    );
  }

  factory SubmissionsHomeworksModel.fromJson(Map<String, dynamic> json){
    return SubmissionsHomeworksModel(
      code: json["code"],
      message: json["message"],
      data: json["data"] == null ? [] : List<SubmissionHomeworkModel>.from(json["data"]!.map((x) => SubmissionHomeworkModel.fromJson(x))),
      pagination: json["pagination"] == null ? null : SubmissionsHomeworksPaginationModel.fromJson(json["pagination"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "data": data.map((x) => x.toJson()).toList(),
    "pagination": pagination?.toJson(),
  };

  @override
  List<Object?> get props => [
    code, message, data, pagination, ];
}

class SubmissionHomeworkModel extends Equatable {
  const SubmissionHomeworkModel({
    required this.id,
    required this.homeworkId,
    required this.homeworkName,
    required this.studentId,
    required this.studentName,
    required this.note,
    required this.submittedAt,
    required this.grade,
    required this.teacherNote,
    required this.files,
  });

  final int? id;
  final int? homeworkId;
  final String? homeworkName;
  final int? studentId;
  final String? studentName;
  final String? note;
  final String? submittedAt;
  final String? grade;
  final String? teacherNote;
  final List<FileModel> files;

  SubmissionHomeworkModel copyWith({
    int? id,
    int? homeworkId,
    String? homeworkName,
    int? studentId,
    String? studentName,
    String? note,
    String? submittedAt,
    String? grade,
    String? teacherNote,
    List<FileModel>? files,
  }) {
    return SubmissionHomeworkModel(
      id: id ?? this.id,
      homeworkId: homeworkId ?? this.homeworkId,
      homeworkName: homeworkName ?? this.homeworkName,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      note: note ?? this.note,
      submittedAt: submittedAt ?? this.submittedAt,
      grade: grade ?? this.grade,
      teacherNote: teacherNote ?? this.teacherNote,
      files: files ?? this.files,
    );
  }

  factory SubmissionHomeworkModel.fromJson(Map<String, dynamic> json){
    return SubmissionHomeworkModel(
      id: json["id"],
      homeworkId: json["homework_id"],
      homeworkName: json["homeworkName"],
      studentId: json["student_id"],
      studentName: json["studentName"],
      note: json["note"],
      submittedAt: json["submitted_at"],
      grade: json["grade"],
      teacherNote: json["teacher_note"],
      files: json["files"] == null ? [] : List<FileModel>.from(json["files"]!.map((x) => FileModel.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "homework_id": homeworkId,
    "homeworkName": homeworkName,
    "student_id": studentId,
    "studentName": studentName,
    "note": note,
    "submitted_at": submittedAt,
    "grade": grade,
    "teacher_note": teacherNote,
    "files": files.map((x) => x.toJson()).toList(),
  };

  @override
  List<Object?> get props => [
    id, homeworkId, homeworkName, studentId, studentName, note, submittedAt, grade, teacherNote, files, ];
}

class SubmissionsHomeworksPaginationModel extends Equatable {
  const SubmissionsHomeworksPaginationModel({
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
  });

  final int? total;
  final int? perPage;
  final int? currentPage;
  final int? lastPage;

  SubmissionsHomeworksPaginationModel copyWith({
    int? total,
    int? perPage,
    int? currentPage,
    int? lastPage,
  }) {
    return SubmissionsHomeworksPaginationModel(
      total: total ?? this.total,
      perPage: perPage ?? this.perPage,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
    );
  }

  factory SubmissionsHomeworksPaginationModel.fromJson(Map<String, dynamic> json){
    return SubmissionsHomeworksPaginationModel(
      total: json["total"],
      perPage: json["per_page"],
      currentPage: json["current_page"],
      lastPage: json["last_page"],
    );
  }

  Map<String, dynamic> toJson() => {
    "total": total,
    "per_page": perPage,
    "current_page": currentPage,
    "last_page": lastPage,
  };

  @override
  List<Object?> get props => [
    total, perPage, currentPage, lastPage, ];
}
