import 'package:equatable/equatable.dart';

class LessonDetailsModel extends Equatable {
  const LessonDetailsModel({
    this.code,
    this.message,
    this.data,
  });

  final int? code;
  final String? message;
  final Lesson2Model? data;

  LessonDetailsModel copyWith({
    int? code,
    String? message,
    Lesson2Model? data,
  }) {
    return LessonDetailsModel(
      code: code ?? this.code,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory LessonDetailsModel.fromJson(Map<String, dynamic> json) {
    return LessonDetailsModel(
      code: json["code"],
      message: json["message"],
      data: json["data"] == null ? null : Lesson2Model.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data?.toJson(),
      };

  @override
  List<Object?> get props => [
        code,
        message,
        data,
      ];
}

class Lesson2Model extends Equatable {
  const Lesson2Model({
    this.id,
    this.course,
    this.name,
    this.image,
    this.videoUrl,
    this.status,
    this.created,
    this.nameEn,
    this.nameAr,
    this.files,
    this.teacher,
  });

  final int? id;
  final String? course;
  final String? name;
  final String? image;
  final String? videoUrl;
  final int? status;
  final String? created;
  final String? nameEn;
  final String? nameAr;
  final List<FileModel>? files;
  final String? teacher;

  Lesson2Model copyWith({
    int? id,
    String? course,
    String? name,
    String? image,
    String? videoUrl,
    int? status,
    String? created,
    String? nameEn,
    String? nameAr,
    List<FileModel>? files,
    String? teacher,
  }) {
    return Lesson2Model(
      id: id ?? this.id,
      course: course ?? this.course,
      name: name ?? this.name,
      image: image ?? this.image,
      videoUrl: videoUrl ?? this.videoUrl,
      status: status ?? this.status,
      created: created ?? this.created,
      nameEn: nameEn ?? this.nameEn,
      nameAr: nameAr ?? this.nameAr,
      files: files ?? this.files,
      teacher: teacher ?? this.teacher,
    );
  }

  factory Lesson2Model.fromJson(Map<String, dynamic> json) {
    return Lesson2Model(
      id: json["id"],
      course: json["course"],
      name: json["name"],
      image: json["image"],
      videoUrl: json["video_url"],
      status: json["status"],
      created: json["created"] ?? "",
      nameEn: json["name_en"],
      nameAr: json["name_ar"],
      files: json["files"] == null
          ? []
          : List<FileModel>.from(
              json["files"]!.map((x) => FileModel.fromJson(x))),
      teacher: json["teacher"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "course": course,
        "name": name,
        "image": image,
        "video_url": videoUrl,
        "status": status,
        "created": created,
        "name_en": nameEn,
        "name_ar": nameAr,
        "files": files?.map((x) => x.toJson()).toList(),
        "teacher": teacher,
      };

  @override
  List<Object?> get props => [
        id,
        course,
        name,
        image,
        videoUrl,
        status,
        created,
        nameEn,
        nameAr,
        files,
        teacher,
      ];
}

class FileModel extends Equatable {
  const FileModel({
    this.id,
    this.lesson,
    this.name,
    this.file,
    this.created,
  });

  final int? id;
  final String? lesson;
  final String? name;
  final String? file;
  final String? created;

  FileModel copyWith({
    int? id,
    String? lesson,
    String? name,
    String? file,
    String? created,
  }) {
    return FileModel(
      id: id ?? this.id,
      lesson: lesson ?? this.lesson,
      name: name ?? this.name,
      file: file ?? this.file,
      created: created ?? this.created,
    );
  }

  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
      id: json["id"],
      lesson: json["lesson"],
      name: json["name"],
      file: json["file"],
      created: json["created"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "lesson": lesson,
        "name": name,
        "file": file,
        "created": created,
      };

  @override
  List<Object?> get props => [
        id,
        lesson,
        name,
        file,
        created,
      ];
}
