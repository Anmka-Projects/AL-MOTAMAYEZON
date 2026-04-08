import 'package:elmotamizon/features/lesson_details/models/lesson_details_model.dart';
import 'package:equatable/equatable.dart';

class Lessons2Model extends Equatable {
  const Lessons2Model({
    required this.code,
    required this.message,
    required this.data,
    required this.pagination,
  });

  final int? code;
  final String? message;
  final List<Lesson2Model> data;
  final LessonsPaginationModel? pagination;

  Lessons2Model copyWith({
    int? code,
    String? message,
    List<Lesson2Model>? data,
    LessonsPaginationModel? pagination,
  }) {
    return Lessons2Model(
      code: code ?? this.code,
      message: message ?? this.message,
      data: data ?? this.data,
      pagination: pagination ?? this.pagination,
    );
  }

  factory Lessons2Model.fromJson(Map<String, dynamic> json) {
    return Lessons2Model(
      code: json["code"],
      message: json["message"],
      data: json["data"] == null
          ? []
          : List<Lesson2Model>.from(
              json["data"]!.map((x) => Lesson2Model.fromJson(x))),
      pagination: json["pagination"] == null
          ? null
          : LessonsPaginationModel.fromJson(json["pagination"]),
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
        code,
        message,
        data,
        pagination,
      ];
}

class LessonsPaginationModel extends Equatable {
  const LessonsPaginationModel({
    required this.total,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
  });

  final int? total;
  final int? currentPage;
  final int? lastPage;
  final int? perPage;

  LessonsPaginationModel copyWith({
    int? total,
    int? currentPage,
    int? lastPage,
    int? perPage,
  }) {
    return LessonsPaginationModel(
      total: total ?? this.total,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      perPage: perPage ?? this.perPage,
    );
  }

  factory LessonsPaginationModel.fromJson(Map<String, dynamic> json) {
    return LessonsPaginationModel(
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
  List<Object?> get props => [
        total,
        currentPage,
        lastPage,
        perPage,
      ];
}
