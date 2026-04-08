import 'package:equatable/equatable.dart';

class VoiceNotesModel extends Equatable {
  const VoiceNotesModel({
    this.code,
    this.message,
    this.data,
    this.pagination,
  });

  final int? code;
  final String? message;
  final List<VoiceNoteModel>? data;
  final PaginationModel? pagination;

  factory VoiceNotesModel.fromJson(Map<String, dynamic> json) {
    return VoiceNotesModel(
      code: json["code"],
      message: json["message"],
      data: (json["data"] as List?)
          ?.map((item) => VoiceNoteModel.fromJson(item))
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

class VoiceNoteModel extends Equatable {
  const VoiceNoteModel({
    this.id,
    this.courseId,
    this.name,
    this.file,
    this.isFree,
    this.isSubscribed,
    this.status,
    this.created,
  });

  final int? id;
  final int? courseId;
  final String? name;
  final String? file;
  final int? isFree;
  final int? isSubscribed;
  final int? status;
  final String? created;

  factory VoiceNoteModel.fromJson(Map<String, dynamic> json) {
    return VoiceNoteModel(
      id: json["id"],
      courseId: json["course_id"],
      name: json["name"],
      file: json["file"],
      isFree: json["is_free"] ?? 0,
      isSubscribed: json["is_subscribed"] ?? 0,
      status: json["status"] ?? 1,
      created: json["created"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "course_id": courseId,
        "name": name,
        "file": file,
        "is_free": isFree,
        "is_subscribed": isSubscribed,
        "status": status,
        "created": created,
      };

  @override
  List<Object?> get props => [
        id,
        courseId,
        name,
        file,
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
