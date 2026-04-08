import 'package:elmotamizon/features/details/models/course_details_model.dart';
import 'package:equatable/equatable.dart';

class CoursesModel extends Equatable {
  const CoursesModel({
    required this.code,
    required this.message,
    required this.data,
    required this.pagination,
  });

  final int? code;
  final String? message;
  final List<CourseModel> data;
  final CoursesPaginationModel? pagination;

  CoursesModel copyWith({
    int? code,
    String? message,
    List<CourseModel>? data,
    CoursesPaginationModel? pagination,
  }) {
    return CoursesModel(
      code: code ?? this.code,
      message: message ?? this.message,
      data: data ?? this.data,
      pagination: pagination ?? this.pagination,
    );
  }

  factory CoursesModel.fromJson(Map<String, dynamic> json){
    return CoursesModel(
      code: json["code"],
      message: json["message"],
      data: json["data"] == null ? [] : List<CourseModel>.from(json["data"]!.map((x) => CourseModel.fromJson(x))),
      pagination: json["pagination"] == null ? null : CoursesPaginationModel.fromJson(json["pagination"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "data": data.map((x) => x.toJson()).toList(),
    "pagination": pagination?.toJson(),
  };

  @override
  List<Object?> get props => [code, message, data, pagination,];
}

class CoursesPaginationModel extends Equatable {
  const CoursesPaginationModel({
    required this.total,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
  });

  final int? total;
  final int? currentPage;
  final int? lastPage;
  final int? perPage;

  CoursesPaginationModel copyWith({
    int? total,
    int? currentPage,
    int? lastPage,
    int? perPage,
  }) {
    return CoursesPaginationModel(
      total: total ?? this.total,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      perPage: perPage ?? this.perPage,
    );
  }

  factory CoursesPaginationModel.fromJson(Map<String, dynamic> json){
    return CoursesPaginationModel(
      total: json["total"],
      currentPage: json["current_page"],
      lastPage: json["last_page"],
      perPage: json["per_page"],
    );
  }

  Map<String, dynamic> toJson() => {
    "total": total,
    "current_page": currentPage,
    "last_page": lastPage,
    "per_page": perPage,
  };

  @override
  List<Object?> get props => [total, currentPage, lastPage, perPage,];
}
