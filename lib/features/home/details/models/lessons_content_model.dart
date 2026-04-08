import 'package:equatable/equatable.dart';

class LessonsContentModel extends Equatable {
  const LessonsContentModel({
    this.code,
    this.message,
    this.data,
    this.pagination,
  });

  final int? code;
  final String? message;
  final List<LessonModel>? data;
  final PaginationModel? pagination;

  factory LessonsContentModel.fromJson(Map<String, dynamic> json) {
    return LessonsContentModel(
      code: json["code"],
      message: json["message"],
      data: (json["data"] as List?)
          ?.map((item) => LessonModel.fromJson(item))
          .toList(),
      pagination: json["pagination"] == null
          ? null
          : PaginationModel.fromJson(json["pagination"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data?.map((e) => e.toJson()).toList(),
        "pagination": pagination?.toJson(),
      };

  @override
  List<Object?> get props => [code, message, data, pagination];
}

class LessonModel extends Equatable {
  const LessonModel({
    this.id,
    this.courseId,
    this.course,
    this.name,
    this.image,
    this.videoUrl,
    this.isFree,
    this.isSubscribed,
    this.status,
    this.created,
  });

  final int? id;
  final int? courseId;
  final String? course;
  final String? name;
  final String? image;
  final String? videoUrl;
  final int? isFree;
  final int? isSubscribed;
  final int? status;
  final String? created;

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json["id"],
      courseId: json["course_id"],
      course: json["course"],
      name: json["name"],
      image: json["image"],
      videoUrl: json["video_url"],
      isFree: json["is_free"] ?? 0,
      isSubscribed: json["is_subscribed"] ?? 0,
      status: json["status"] ?? 1,
      created: json["created"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "course_id": courseId,
        "course": course,
        "name": name,
        "image": image,
        "video_url": videoUrl,
        "is_free": isFree,
        "is_subscribed": isSubscribed,
        "status": status,
        "created": created,
      };

  @override
  List<Object?> get props => [
        id,
        courseId,
        course,
        name,
        image,
        videoUrl,
        isFree,
        isSubscribed,
        status,
        created,
      ];
}

class PaginationModel extends Equatable {
  const PaginationModel({
    this.total,
    this.currentPage,
    this.lastPage,
    this.perPage,
  });

  final int? total;
  final int? currentPage;
  final int? lastPage;
  final int? perPage;

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
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
  List<Object?> get props => [total, currentPage, lastPage, perPage];
}
