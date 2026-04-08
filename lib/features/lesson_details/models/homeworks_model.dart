import 'package:elmotamizon/features/lesson_details/models/lesson_details_model.dart';
import 'package:equatable/equatable.dart';

class HomeworksModel extends Equatable {
  const HomeworksModel({
    required this.code,
    required this.message,
    required this.data,
    required this.pagination,
  });

  final int? code;
  final String? message;
  final List<HomeworkModel> data;
  final Pagination? pagination;

  HomeworksModel copyWith({
    int? code,
    String? message,
    List<HomeworkModel>? data,
    Pagination? pagination,
  }) {
    return HomeworksModel(
      code: code ?? this.code,
      message: message ?? this.message,
      data: data ?? this.data,
      pagination: pagination ?? this.pagination,
    );
  }

  factory HomeworksModel.fromJson(Map<String, dynamic> json){
    return HomeworksModel(
      code: json["code"],
      message: json["message"],
      data: json["data"] == null ? [] : List<HomeworkModel>.from(json["data"]!.map((x) => HomeworkModel.fromJson(x))),
      pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
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

class HomeworkModel extends Equatable {
  const HomeworkModel({
    required this.id,
    required this.lesson,
    required this.image,
    required this.name,
    required this.created,
    required this.nameAr,
    required this.nameEn,
    required this.files,
  });

  final int? id;
  final String? lesson;
  final String? image;
  final String? name;
  final String? created;
  final String? nameAr;
  final String? nameEn;
  final List<FileModel> files;

  HomeworkModel copyWith({
    int? id,
    String? lesson,
    String? image,
    String? name,
    String? created,
    String? nameAr,
    String? nameEn,
    List<FileModel>? file,
  }) {
    return HomeworkModel(
      id: id ?? this.id,
      lesson: lesson ?? this.lesson,
      image: image ?? this.image,
      name: name ?? this.name,
      created: created ?? this.created,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      files: file ?? files,
    );
  }

  factory HomeworkModel.fromJson(Map<String, dynamic> json){
    return HomeworkModel(
      id: json["id"],
      lesson: json["lesson"],
      image: json["image"],
      name: json["name"],
      created: json["created"] ?? "",
      nameAr: json["name_ar"],
      nameEn: json["name_en"],
      files: json["files"] == null ? [] : List<FileModel>.from(json["files"]!.map((x) => FileModel.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "lesson": lesson,
    "image": image,
    "name": name,
    "created": created,
    "name_ar": nameAr,
    "name_en": nameEn,
    "files": files.map((x) => x.toJson()).toList(),
  };

  @override
  List<Object?> get props => [
    id, lesson, image, name, created, nameAr, nameEn, files, ];
}

class Pagination extends Equatable {
  const Pagination({
    required this.total,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
  });

  final int? total;
  final int? currentPage;
  final int? lastPage;
  final int? perPage;

  Pagination copyWith({
    int? total,
    int? currentPage,
    int? lastPage,
    int? perPage,
  }) {
    return Pagination(
      total: total ?? this.total,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      perPage: perPage ?? this.perPage,
    );
  }

  factory Pagination.fromJson(Map<String, dynamic> json){
    return Pagination(
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
    total, currentPage, lastPage, perPage, ];
}
